import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'settings.dart';

/// Owns the widget WebView. Keep one instance for the app lifetime so the
/// conversation and unread count survive opening/closing the panel.
class HubChatController extends ChangeNotifier {
  HubChatController({required this.widgetKey, this.baseUrl = hubChatDefaultBaseUrl}) {
    _webView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xfff4f6fa))
      ..addJavaScriptChannel('HubChatBridge', onMessageReceived: (message) => _onBridge(message.message));

    final platform = _webView.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
      platform.setOnShowFileSelector(_pickFiles);
    }
  }

  final String widgetKey;
  final String baseUrl;
  late final WebViewController _webView;

  HubChatSettings? settings;
  bool isOpen = false;
  int unread = 0;
  bool _loaded = false;

  /// Called for every event from the widget: ready, close, unread.
  void Function(Map<String, dynamic> event)? onEvent;

  WebViewController get webView => _webView;

  Future<void> initialize() async {
    settings = await HubChatSettings.fetch(baseUrl, widgetKey);
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 2500), load);
  }

  /// Loads the widget page (also done on idle, like widget.js, so unread messages arrive while closed).
  void load() {
    if (_loaded) return;
    _loaded = true;
    _webView.loadRequest(Uri.parse('$baseUrl/widget/$widgetKey'));
  }

  void open() {
    load();
    isOpen = true;
    unread = 0;
    _command('open');
    notifyListeners();
  }

  void close() {
    isOpen = false;
    _command('closed');
    notifyListeners();
  }

  void _command(String type) {
    _webView.runJavaScript("window.postMessage({source:'hubchat-loader',type:'$type'},'*');").catchError((_) {});
  }

  void _onBridge(String raw) {
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    if (data['source'] != 'hubchat') return;

    switch (data['type']) {
      case 'close':
        close();
      case 'ready':
        if (isOpen) _command('open');
      case 'unread':
        if (!isOpen) {
          unread = (data['count'] as num?)?.toInt() ?? unread + 1;
          notifyListeners();
        }
    }
    onEvent?.call(data);
  }

  Future<List<String>> _pickFiles(FileSelectorParams params) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: params.mode == FileSelectorMode.openMultiple);
    return result?.files.where((f) => f.path != null).map((f) => Uri.file(File(f.path!).path).toString()).toList() ?? [];
  }
}
