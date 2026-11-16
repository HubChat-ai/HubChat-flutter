# hubchat (Flutter)

ویجت چت پشتیبانی هاب‌چت برای اپ فلاتر، با همان ظاهر و امکانات ویجت سایت.

## امکانات
- دکمه‌ی شناور با رنگ، آیکن، متن و جایگاهی که در پنل هاب‌چت تنظیم کرده‌اید
- پنل گفتگو با همان ظاهر و امکانات ویجت سایت: ارسال فایل و عکس، پایگاه دانش، ساعات کاری و نظرسنجی رضایت
- شمارنده‌ی پیام‌های خوانده‌نشده روی دکمه، حتی وقتی پنل بسته است
- تغییر ظاهر از پنل، بدون نیاز به انتشار نسخه‌ی جدید اپ
- پیام‌های کاربران در صندوق ورودی هاب‌چت، کنار تلگرام، بله، روبیکا و بقیه‌ی کانال‌ها

## کلید کانال
کلید را از پنل هاب‌چت بگیرید: «تنظیمات > کانال‌ها > افزودن کانال > اپلیکیشن موبایل». کلید با `hc_` شروع می‌شود و در صفحه‌ی همان کانال، کنار نمونه‌کد نصب، نمایش داده می‌شود.

## نصب
```bash
flutter pub add hubchat
```

یا در `pubspec.yaml`:

```yaml
dependencies:
  hubchat: ^1.0.4
```

## استفاده
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


### صفحه‌ی فعلی کاربر

اپراتور کنار گفتگو می‌بیند کاربر الان در کدام صفحه‌ی اپ است و آن صفحه در آمار بازدید پنل هم می‌آید:

```dart
hubChat.setScreen('checkout', title: 'تکمیل خرید');
```

### معرفی کاربر لاگین‌کرده

```dart
hubChat.identify({
  'user_id': user.id,
  'name': user.fullName,
  'mobile': user.mobile,
  'custom': {'plan': 'VIP'},
  'signature': signatureFromYourServer, // HMAC-SHA256 شناسه با کلید مخفی، روی سرور
});

hubChat.logout(); // هنگام خروج از حساب
```

همه‌ی فیلدها و روش ساخت امضا: https://hubchat.ir/docs/widget-identify

## تنظیمات پلتفرم
**اندروید:** `<uses-permission android:name="android.permission.INTERNET"/>` و `minSdk 21`.
**iOS:** کلیدهای `NSCameraUsageDescription`، `NSPhotoLibraryUsageDescription` و `NSMicrophoneUsageDescription` در `Info.plist`.

## پشتیبانی
- مستندات: https://hubchat.ir/docs/connect-channel/mobile_sdk
- گزارش مشکل: بخش Issues همین مخزن
- وب‌سایت: https://hubchat.ir
