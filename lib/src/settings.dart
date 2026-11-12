import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;

const String hubChatDefaultBaseUrl = 'https://widget.hubchat.ir';

/// Launcher settings configured in the HubChat panel (GET /widget/{key}/config).
class HubChatSettings {
  HubChatSettings({required this.color, required this.position, this.launcherText, this.launcherImage, this.title, this.subtitle});

  final Color color;
  final String position;
  final String? launcherText;
  final String? launcherImage;
  final String? title;
  final String? subtitle;

  bool get isRight => position == 'right';

  factory HubChatSettings.fromJson(Map<String, dynamic> json) {
    final hex = (json['color'] as String? ?? '#2563eb').replaceFirst('#', '');
    String? text(String key) => (json[key] as String?)?.trim().isEmpty ?? true ? null : json[key] as String;

    return HubChatSettings(
      color: Color(int.parse('ff$hex', radix: 16)),
      position: json['position'] as String? ?? 'left',
      launcherText: text('launcher_text'),
      launcherImage: text('launcher_image'),
      title: text('title'),
      subtitle: text('subtitle'),
    );
  }

  /// Same contrast rule as widget.js.
  Color get onColor => color.computeLuminance() > 0.45 ? const Color(0xff0b1220) : const Color(0xffffffff);

  static Future<HubChatSettings?> fetch(String baseUrl, String widgetKey) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/widget/$widgetKey/config'));
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return HubChatSettings.fromJson(data['settings'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

String hubChatFaDigits(Object value) => value.toString().replaceAllMapped(RegExp(r'\d'), (m) => '۰۱۲۳۴۵۶۷۸۹'[int.parse(m[0]!)]);
