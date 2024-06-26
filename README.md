
# Tích Hợp HotLine Flutter SDK

<!--BEGIN_DESCRIPTION-->
Để tích hợp gọi hot line OTT cần 3 bước, tương ứng với 3 hàm trong SDK `ALICMM.config`, `ALICMM.login`, `ALICMM.startHotlineCall` trong đó các tham số key service được đăng ký trên [CRM ALI](http://crm.ali.vn/)
<!--END_DESCRIPTION-->

## Vui lòng lấy các key tương ứng và ghi đè lại [CRM ALI](http://crm.ali.vn/)

Tham số key chứng thực
```dart
  final REPLACE_WITH_username = 'REPLACE_WITH_username';
  final REPLACE_WITH_credential = 'REPLACE_WITH_credential';
  final REPLACE_WITH_secret = 'REPLACE_WITH_secret';
```
Tham số cấu hình websocket
```dart
  final REPLACE_WITH_host = 'REPLACE_WITH_host';
  final REPLACE_WITH_hostUrlWebSocket = 'REPLACE_WITH_hostUrlWebSocket';
  final REPLACE_WITH_hostUrlHotlineWebSocket =
      'REPLACE_WITH_hostUrlHotlineWebSocket';
  final REPLACE_WITH_turnHostWebSocket = 'REPLACE_WITH_turnHostWebSocket';
  final REPLACE_WITH_stunHostWebSocket = 'REPLACE_WITH_stunHostWebSocket';
```
Tham số host line
```dart
  final REPLACE_WITH_id = 'REPLACE_WITH_id';
  final REPLACE_WITH_key = 'REPLACE_WITH_key';
  final REPLACE_WITH_code = 'REPLACE_WITH_code';
  final REPLACE_WITH_name = 'REPLACE_WITH_name';
  final REPLACE_WITH_image_url = 'REPLACE_WITH_image_url';
```

## App demo
Github example : https://github.com

## Cấu hình

Thêm thư viện trong `pubspec.yaml`

```yaml
---
dependencies:
  equatable: ^2.0.3
  flutter_ali_cmm:
    #path local file
    path: ../flutter_ali_cmm
```

### iOS
Ưu cầu iOs tối thiểu: 14.0 
Quyền khai báo audio trong `Info.plist` file.

```xml
<dict>
  ...
  <key>NSMicrophoneUsageDescription</key>
  <string>$(PRODUCT_NAME) uses your microphone</string>
```

Xin thêm quyền audio ở back ground mode
Trong `Info.plist`

```xml
<dict>
  ...
  <key>UIBackgroundModes</key>
  <array>
    <string>audio</string>
  </array>
```
Thêm FW `CallKit.frameworks` trong `Frameworks, Libraries, and Embedded Content`
### Android

Thêm các quyền trong app/main/ `AndroidManifest.xml`.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.your.package">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_PHONE_CALL"/>
    <uses-permission android:name="android.permission.MANAGE_OWN_CALLS"/>
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  ...
</manifest>
```
Trong thưc mục android `build.grade`.
```grade
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url "https://jitpack.io"
        }
        maven {
            url "https://webgit.taxidayroi.vn/api/v4/projects/430/packages/maven"
            name "GitLab"
            credentials(HttpHeaderCredentials) {
                name = 'Deploy-Token'
                value = 'jQroyDaWNrxxvYN6Z5xY'
            }
            authentication {
                header(HttpHeaderAuthentication)
            }
        }
    }
}
```
Chỉnh sửa `ext.kotlin_version = '1.8.0'` verison trong `buildscript` và build grade `classpath 'com.android.tools.build:gradle:7.4.2'`
```grade
buildscript {
    ext.kotlin_version = '1.8.0'
    repositories {
        google()
        mavenCentral()

    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.4.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```
Trong thưc mục android/app `build.grade`.
```grade
    dependencies {
        ... 
        implementation 'com.tot:audiocall:1.1.0'
    }
```
## Sử dụng `flutter_ali_cmm` trong flutter
Khai báo package sdk 
```dart
    import 'package:flutter_ali_cmm/flutter_ali_cmm.dart';
```
### Ưu cầu Xin quyền auudio thông qua hàm `ALICMM.getPermission()` trước khi thực hiện cuộc gọi
```dart
 await ALICMM.getPermission();
```
### Cấu hình môi trường `ALICMM.config`
```dart
    final ser = ALICMMServerConfig(
      //online
      host: REPLACE_WITH_host,
      hostUrlWebSocket: REPLACE_WITH_hostUrlWebSocket,
      hostUrlHotlineWebSocket: REPLACE_WITH_hostUrlHotlineWebSocket,
      turnHostWebSocket: REPLACE_WITH_turnHostWebSocket,
      stunHostWebSocket: REPLACE_WITH_stunHostWebSocket,
    );
    ALICMM.config(ser, 'sandbox');
```
### Sử dụng đăng nhập để chứng thực hợp lệ `ALICMM.login` qua các key đã đăng ký trước đó.
```dart
    ALICMM.login(
      'Số điện thoại đăng nhập app',
      ALICMMCallConfig(
        username: REPLACE_WITH_username,
        credential: REPLACE_WITH_credential,
        secret: REPLACE_WITH_secret,
      ),
    );
```
### Gọi tổng đài `ALICMM.startHotlineCall` thông qua param tương ứng `ALICMMCall.fromHotlineConfig` như sau  
```dart
    var param = ALICMMCall.fromHotlineConfig(
      hotlineConfig: ALICMMHotlineConfig(
        id: REPLACE_WITH_id,
        key: REPLACE_WITH_key,
        code: REPLACE_WITH_code,
        name: REPLACE_WITH_name,
        image: REPLACE_WITH_image_url ,
      ),
      callerId: 'Số điện thoại đăng nhập app',
      callerAvatar: 'url hình ảnh ngừoi gọi',
      username: REPLACE_WITH_username,
      credential: REPLACE_WITH_credential,
      secret: REPLACE_WITH_secret,
    );

    ALICMM.startHotlineCall(param);
```

### Sau khi thêm các sự kiện cần đăng ký 1 event call back để hiện thị màn hình cuộc gọi.
Khai báo event call 
```dart
    final ALiCMMEventCallbacks _eventCallbacks = ALiCMMEventCallbacks();
```
Trong hàm init khai báo sự kiện  
```dart
    _eventCallbacks.setEventCallbacks(
      onUpdatePushKitToken: (pushToken) {
        //Dùng trong cuộc gọi P2P, đăng ký pushkit token
      },
      onNotifyCall: (notifyCallData) async {
         //Dùng trong cuộc gọi P2P, gọi api thông báo có cuộc gọi
      },
      onRequestShowCall: (call) {
        // Hiện màn hình cuộc gọi 
        toCallPageScreen(context, call);
      },
    );
```
mở màn hình cuộc gọi trong  `PageCall` truyền `ALICMMCall` được trả về trong call back
```dart
    toCallPageScreen(BuildContext context, ALICMMCall call) {
        Future.delayed(Duration.zero, () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageCall(call)),
          );
        });
    }
```
###  Handle event state của cuộc gọi thông qua hàm `AliCMMCallEventCallbacks` được trả về call back, khi cuộc gọi bắt đầu kết nối
```dart
    final AliCMMCallEventCallbacks _callEventCallbacks = AliCMMCallEventCallbacks();
```
đăng ký event call back trả về khi có trạng thái cuộc gọi diễn ra, khai báo trong init của màn hình cuộc gọi
```dart
    _callEventCallbacks.setCallEventCallbacks(
      onCallStateChange: (state) {
        if (mounted) {
          setState(() {
            handleStageCall(state);
          });
        }
      },
      onCallConnectedChange: (connectedState, connectedDate) => {
        if (mounted)
          {
            setState(() {
              callConnectedState = connectedState;
              connectedTime = connectedDate;
              if (callConnectedState ==
                      ALICMMCallConnectedState.ALICMMConnectedStateComplete &&
                  connectedTime != null) {
                handleStageCall(ALICMMCallState.ALICMMCallStateActive);
              }
            })
          }
      },
    );
```
trong đó, `onCallStateChange` là trạng thái cuộc gọi diễn ra, gồm các trạng thái 
`ALICMMCallStateEnded` : kết thúc cuộc gọi,
`ALICMMCallStatePending` : cuộc gọi đang bắt đầu kết nối, 
`ALICMMCallStateActive`: cuộc gọi đã kết nối
khi bên tổng đài chấp nhận cuộc gọi, hoặc kết thúc cuộc gọi thì có event trả về trong `onCallStateChange` trả về trạng thái để handle UI
`onCallConnectedChange` là trạng thái kết nối cuộc gọi đang diễn ra qua qua trạng `ALICMMCallConnectedState`, khi 2 bên kết nối thành công sẽ trả về thời gian bắt đầu cuộc gọi  connectedDate: DateTime != null, để hiện thị thời gian, và trạng thái kết nối 
`ALICMMConnectedStateComplete`: thành công, ngược lại `ALICMMConnectedStatePending` đang kết nối, và thời gian trả về connectedDate: DateTime = null

chi tiết trong UI PageCall trong demo đính kèm.

###  Các sự kiện handle cuộc gọi
chấp nhận cuộc gọi
```dart
    ALICMM.answerIncomingCall();
```
kết thúc cuộc gọi
```dart
    ALICMM.endCall();
```
Từ chối cuộc gọi
```dart
     ALICMM.denyIncomingCall();
```
Bật tắt mic
```dart
    mute = !mute;
    ALICMM.setMuteCall(mute);
```
Bật tắt loa ngoài
```dart
    speaker = !speaker;
    ALICMM.setSpeakOn(speaker);
```
