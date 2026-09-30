# Hướng dẫn chạy 9 Lab bằng Android Studio và máy ảo

## 1. Cài môi trường

1. Cài Flutter SDK và thêm `flutter/bin` vào PATH.
2. Cài Android Studio.
3. Mở Android Studio > SDK Manager, cài Android SDK Platform và Android SDK Platform-Tools.
4. Mở Device Manager > Create Device > chọn Pixel 6 hoặc Pixel 7 > chọn system image Android  API 35/36 > Finish.
5. Khởi động máy ảo bằng nút Play.
6. Mở terminal và chạy `flutter doctor`. Nếu còn lỗi, sửa hết các mục Android toolchain trước khi chạy.

## 2. Mở một lab

1. Android Studio > Open.
2. Chọn đúng thư mục, ví dụ `flutter-9-labs/lab_03_dice`.
3. Chờ Android Studio tải Flutter/Dart indexing.
4. Chọn thiết bị ảo ở thanh thiết bị.
5. Mở `pubspec.yaml`, bấm Pub get hoặc chạy:

```bash
flutter pub get
```

6. Mở `lib/main.dart` và bấm Run.

## 3. Chạy bằng terminal

```bash
cd D:/code/Nam_4_ki1/DiDongDaNenTang/lab/flutter-9-labs/lab_01_i_am_rich
flutter pub get
flutter devices
flutter run
```

Build APK thử nghiệm:

```bash
flutter build apk --debug
```

APK nằm trong `build/app/outputs/flutter-apk/app-debug.apk`.

## 4. Cách dạy/demo từng bài

- Lab 1: giới thiệu MaterialApp, Scaffold, Icon, Text và bố cục Column.
- Lab 2: giải thích Card, ListTile, CircleAvatar và dữ liệu danh thiếp.
- Lab 3: nhấn ROLL DICE, giải thích Random, StatefulWidget và setState.
- Lab 4: nhấn ASK THE BALL, giải thích danh sách câu trả lời và random index.
- Lab 5: lần lượt nhấn 7 phím màu, giải thích callback và package âm thanh; bản mẫu hiện thông báo tương tác để chạy ngay.
- Lab 6: trả lời TRUE/FALSE, giải thích class Question, kiểm tra đáp án, score icons và reset.
- Lab 7: chọn hai hướng truyện, giải thích Story, chỉ số next story và trạng thái kết thúc.
- Lab 8: đổi giới tính, kéo chiều cao, đổi cân nặng/tuổi, bấm CALCULATE và RE-CALCULATE; giải thích Navigator và công thức BMI.
- Lab 9: nhập Da Nang để xem demo mode; thêm API key rồi tìm thành phố thật; giải thích HTTP, JSON, loading và lỗi API.

## 5. Lab 9 - OpenWeatherMap

Mở `lab_09_clima/lib/main.dart`, thay:

```dart
const String openWeatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
```

bằng key của bạn. Khi public GitHub, hãy đổi lại placeholder, hoặc dùng biến môi trường/secret riêng.

## 6. Lỗi thường gặp

- `No devices`: khởi động AVD hoặc bật USB debugging trên điện thoại.
- `flutter pub get` lỗi: kiểm tra mạng, phiên bản Flutter và đường dẫn project.
- App không cập nhật: chạy `flutter clean`, sau đó `flutter pub get` và Run lại.
- Lab 9 không có dữ liệu: kiểm tra API key, tên thành phố và kết nối mạng của máy ảo.
