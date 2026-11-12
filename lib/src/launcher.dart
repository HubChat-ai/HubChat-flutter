import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'controller.dart';
import 'settings.dart';

/// Wrap your app (e.g. in MaterialApp.builder) to show the floating launcher
/// and the full-screen chat panel above every screen.
class HubChat extends StatefulWidget {
  const HubChat({super.key, required this.controller, required this.child, this.showLauncher = true, this.bottomOffset = 0});

  final HubChatController controller;
  final Widget child;
  final bool showLauncher;
  final double bottomOffset;

  @override
  State<HubChat> createState() => _HubChatState();
}

class _HubChatState extends State<HubChat> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.settings == null) widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final c = widget.controller;
        return PopScope(
          canPop: !c.isOpen,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && c.isOpen) c.close();
          },
          child: Stack(
            textDirection: TextDirection.ltr,
            children: [
              widget.child,
              // The WebView stays mounted (Offstage) so the session keeps running while closed.
              Positioned.fill(
                child: Offstage(
                  offstage: !c.isOpen,
                  child: Material(color: const Color(0xfff4f6fa), child: SafeArea(child: WebViewWidget(controller: c.webView))),
                ),
              ),
              if (widget.showLauncher && c.settings != null && !c.isOpen)
                Positioned(
                  bottom: 20 + widget.bottomOffset + MediaQuery.paddingOf(context).bottom,
                  left: c.settings!.isRight ? null : 20,
                  right: c.settings!.isRight ? 20 : null,
                  child: HubChatLauncher(settings: c.settings!, unread: c.unread, onPressed: c.open),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The floating button, matching the website launcher.
class HubChatLauncher extends StatelessWidget {
  const HubChatLauncher({super.key, required this.settings, required this.onPressed, this.unread = 0});

  final HubChatSettings settings;
  final VoidCallback onPressed;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final hasText = settings.launcherText != null;
    final on = settings.onColor;
    final brand = settings.color;
    final light = Color.lerp(brand, Colors.white, 0.18)!;

    Widget icon = settings.launcherImage != null
        ? ClipOval(child: Image.network(settings.launcherImage!, width: hasText ? 44 : 60, height: hasText ? 44 : 60, fit: BoxFit.cover))
        : Icon(Icons.chat_bubble_outline_rounded, color: on, size: 28);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            button: true,
            label: 'گفتگوی آنلاین',
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                height: 60,
                constraints: const BoxConstraints(minWidth: 60),
                padding: EdgeInsets.symmetric(horizontal: hasText && settings.launcherImage == null ? 16 : (hasText ? 8 : 0)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [light, brand]),
                  boxShadow: [
                    BoxShadow(color: brand.withValues(alpha: 0.55), blurRadius: 30, offset: const Offset(0, 10), spreadRadius: -8),
                    BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    icon,
                    if (hasText) ...[
                      const SizedBox(width: 10),
                      Text(settings.launcherText!, style: TextStyle(color: on, fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (unread > 0)
            Positioned(
              top: -4,
              right: settings.isRight ? null : -4,
              left: settings.isRight ? -4 : null,
              child: Container(
                constraints: const BoxConstraints(minWidth: 22),
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: const Color(0xffef4444), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white, width: 3)),
                child: Text(hubChatFaDigits(unread > 9 ? '9+' : unread), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ),
        ],
      ),
    );
  }
}
