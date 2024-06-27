# Tích hợp thư viện Flutter

## Thông tin cấu hình

- Cấu hình tổng đài: `SERVICE_ID`, `SERVICE_KEY`, `SERVICE_NAME`, `SERVICE_AVATAR`.

## Cấu hình Flutter

### Cài đặt thư viện

```yaml
dependencies:
  flutter:
  ...
  flutter_ali_ott_hotline: ^0.0.1
```

## Cấu hình Android

### Yêu cầu

- Android SDK version 24 trở lên

### Cài đặt thư viện

#### Cấu hình maven repository trong file `build.gradle` ở project level:

```gradle
repositories{
  maven {
      url 'https://maven.pkg.github.com/Ali-Corp/AliOTT'
      credentials {
          username "alicorpvn"
          password "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"
      }
  }
}
```

#### Khi báo thư viện trong file `build.gradle` ở app level:

```gradle
dependencies {
  implementation 'vn.ali.ott:hotline:1.0.6'
}
```

## Cấu hình iOS

### Yêu cầu

- iOS 14.0 trở lên

## Thư viện

- Chạy lệnh:

```bash
pod install
```

### Cấu hình Xcode project

- Cấu hình Voice over IP:

  - Chọn **Target** -> **Signing & Capabilities**
  - Thêm **Background Modes** nếu chưa có, sau đó đánh dấu chọn **Voice over IP**

![iOS Enable VoIP](./img/ios_enable_voip.png)

- Cấu hình quyền sử dụng Microphone:
  - Chọn **Target** -> **Info**
  - Thêm key **Privacy - Microphone Usage Description** và nội dung để xin quyền sử dụng Microphone

![iOS Enable Permission Microphone](./img/ios_enable_permission_microphone.png)

### Khởi tạo thư viện Flutter

#### Khai báo thư viện

```dart
    import 'package:flutter_ali_ott_hotline/flutter_ali_ott_hotline.dart';
```

```dart
final _flutterAliOttHotlinePlugin = FlutterAliOttHotline();


_flutterAliOttHotlinePlugin.startListenEvent();
_flutterAliOttHotlinePlugin.setEventCallbacks(
    onInitSuccess: () => {debugPrint("Init success")},
    onInitFail: () => {debugPrint("Init fail")},
    onRequestShowCall: (ALIOTTCall call) => {debugPrint("onRequestShowCall") });
_flutterAliOttHotlinePlugin.config(
  "production", // Môi trường 'sanbox' | 'production'
  ALIOTTHotlineConfig(
    id: `SERVICE_ID`,
    key: `SERVICE_KEY`,
    name: `SERVICE_NAME`,
    icon: `SERVICE_AVATAR`,
  ),
);
```

### Thực hiện cuộc gọi

```dart
_flutterAliOttHotlinePlugin.startHotlineCall(
  `CALLER_ID`, // Id của người gọi (Ví dụ như số điện thoại) (Bắt buộc)
  `CALLER_NAME`, // Tên của người gọi (Bắt buộc)
  `CALLER_AVATAR`, // Hình ảnh đại diện của người gọi (Tuỳ chọn)
);
```

### Hiện thực màn hình gọi

#### Các action liên quan

```dart
_flutterAliOttHotlinePlugin.endCall(); // Kết thúc cuộc gọi
```

```dart
_flutterAliOttHotlinePlugin.setMuteCall(mute); // true / false Tắt/Mở microphone
```

```dart
_flutterAliOttHotlinePlugin.setSpeakOn(speaker); // true / false Chuyển đổi loa ngoài / loa trong
```

#### Lắng nghe sự kiện cuộc gọi

```dart
_flutterAliOttHotlinePlugin.startListenCallEvent();
_flutterAliOttHotlinePlugin.setCallEventCallbacks(
  onCallStateChange: (ALIOTTCallState state) {
    // Lắng nghe sự kiện trạng thái cuộc gọi thay đổi
  },
  onCallConnectedChange: (ALIOTTCallConnectedState connectedState, DateTime? connectedDate) => {
    // Lắng nghe sự kiện cuộc gọi kết nối thành công
  },
);
```

#### Note:

- `ALIOTTCallState` : trạng thái cuộc gọi

  - `ALIOTTCallStateEnded` : kết thúc cuộc gọi,
  - `ALIOTTCallStatePending` : cuộc gọi đang bắt đầu kết nối,
  - `ALIOTTCallStateActive` : cuộc gọi đã kết nối

- `ALIOTTCallConnectedState` : trạng thái kết nối cuộc gọi
  - `ALIOTTConnectedStatePending` : đang kết nối
  - `ALIOTTConnectedStateComplete` : thành công, và đông thời trả về `connectedDate` thời gian bắt đầu cuộc gọi

## Ví dụ hoàn chỉnh

[FlutterExample](https://github.com/Ali-Corp/flutter-ali-ott-hotline/tree/main/example)

