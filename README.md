# hubchat (Flutter)

ویجت چت پشتیبانی هاب‌چت برای اپ فلاتر، با همان ظاهر و امکانات ویجت سایت.

```yaml
dependencies:
  hubchat:
    git:
      url: https://github.com/HubChat-ai/hubchat-flutter.git
      ref: 1.0.0
```

```dart
final hubChat = HubChatController(widgetKey: 'hc_xxxxxxxxxxxxxxxxxxxxxxxx');

MaterialApp(
  builder: (context, child) => HubChat(controller: hubChat, bottomOffset: 56, child: child!),
);

// باز کردن از هر جای اپ:
ElevatedButton(onPressed: hubChat.open, child: const Text('پشتیبانی'));
```

- `showLauncher: false` دکمه‌ی شناور را پنهان می‌کند تا فقط با `hubChat.open()` باز شود.
- `hubChat.unread` و `hubChat.onEvent` برای نمایش تعداد پیام خوانده‌نشده در UI خودتان.

**اندروید:** `<uses-permission android:name="android.permission.INTERNET"/>` و `minSdk 21`.
**iOS:** کلیدهای `NSCameraUsageDescription`، `NSPhotoLibraryUsageDescription` و `NSMicrophoneUsageDescription` در `Info.plist`.

## نحوه‌ی کار
تنظیمات دکمه از `GET https://widget.hubchat.ir/widget/{key}/config` خوانده و دکمه‌ی شناور به‌صورت نیتیو ساخته می‌شود. خود صفحه‌ی ویجت (`/widget/{key}`)، همان صفحه‌ای که روی سایت در iframe باز می‌شود، در WebView بارگذاری می‌شود؛ پس ظاهر و امکانات پنل دقیقاً مثل سایت است. SDK پیش از بارگذاری صفحه `window.HubChatBridge.postMessage` را تعریف می‌کند و ویجت رویدادهای `ready`، `close` و `unread` را از آن می‌فرستد.
