# Flutter 9 Labs

Nine independent Flutter lab projects for Android Studio and an Android Virtual Device.

All nine labs are verified-consistent: matching Android `namespace`, `MainActivity.kt`
package path, and Gradle **Kotlin DSL** files. A single scripted entry point runs any
lab on the emulator.

## Version pinning (important)

This machine's Gradle **9.3.1 cannot compile Kotlin DSL scripts** — even a bare
`settings.gradle.kts` containing only `println("hi")` fails with
`Unresolved reference 'println'`. Gradle 9.1.0 works correctly.

| Component | Version used | Why |
|---|---|---|
| Gradle | **9.1.0** | 9.3.1 is broken here; 9.1.0 satisfies AGP 9.0.x |
| AGP | **9.0.1** | Requires Gradle >= 9.1.0 |
| Kotlin | **2.2.20** | Matches Gradle 9.1.0's bundled Kotlin 2.2 runtime |
| Java | JBR 21 | `C:\Program Files\Android\Android Studio\jbr` |

All 9 labs verified: `gradle help` reports **BUILD SUCCESSFUL** for every project.

## 📚 Danh Sách 9 Labs & Links Nộp Bài

| STT | Tên Lab / Dự án | Mô tả kiến thức & tính năng | Link Repo Chi Tiết |
|:---:|---|---|:---:|
| 1 | **Lab 01 - I Am Rich** | Layout cơ bản, hiển thị Asset Image, cấu hình Material App | [📂 Xem Lab 01](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_01_i_am_rich) |
| 2 | **Lab 02 - MiCard** | Custom fonts, Card, ListTile, bố cục Column / Row | [📂 Xem Lab 02](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_02_micard) |
| 3 | **Lab 03 - Dice** | Quản lý trạng thái `setState`, random xúc xắc | [📂 Xem Lab 03](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_03_dice) |
| 4 | **Lab 04 - Magic 8 Ball** | Quản lý State, toán tử 3 ngôi, hiển thị ảnh ngẫu nhiên | [📂 Xem Lab 04](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_04_magic_8_ball) |
| 5 | **Lab 05 - Xylophone** | Phát âm thanh `audioplayers`, widget `Expanded`, hàm Callback | [📂 Xem Lab 05](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_05_xylophone) |
| 6 | **Lab 06 - Quizzler** | Mô hình hóa dữ liệu (OOP / Models), quản lý điểm số Quiz | [📂 Xem Lab 06](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_06_quizzler) |
| 7 | **Lab 07 - Destini** | Cây lựa chọn cốt truyện (Story Graph), điều hướng `Navigator` | [📂 Xem Lab 07](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_07_destini) |
| 8 | **Lab 08 - BMI Calculator** | Custom Widgets tái sử dụng, Theme tùy chỉnh, tính chỉ số BMI | [📂 Xem Lab 08](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_08_bmi_calculator) |
| 9 | **Lab 09 - Clima** | Lập trình bất đồng bộ (`async`/`await`), gọi REST API thời tiết | [📂 Xem Lab 09](https://github.com/LeNhatHuyHyDrex/flutter-9-labs/tree/main/lab_09_clima) |

## Option A - one command (recommended)

Start an emulator first (Android Studio > Device Manager > Play), then:

```powershell
cd D:\code\Nam_4_ki1\DiDongDaNenTang\lab\flutter-9-labs

.\run_lab.ps1 1              # run lab 1 on emulator-5554
.\run_lab.ps1 3 -Clean       # clean, then run
.\run_lab.ps1 9 -Build       # only build the debug APK
.\run_lab.ps1 6 -Device emulator-5556
.\run_lab.ps1 1 -Doctor      # flutter doctor -v
```

The script pins `JAVA_HOME` to Android Studio's JBR (Java 21), because Gradle 9
does not work with the system Java 22.

If PowerShell blocks the script:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Option B - Android Studio

1. `File > Open` and select one lab folder (e.g. `lab_03_dice`).
2. Wait for Gradle sync.
3. Pick your AVD in the device dropdown and press Run.

Open `ANDROID_STUDIO_GUIDE.md` for the full walkthrough.

## Option C - raw Flutter CLI

```powershell
cd lab_03_dice
flutter pub get
flutter run -d emulator-5554
```

## Notes

- Lab 5 is dependency-ready (`audioplayers`) and shows an interaction fallback when
  audio assets are missing. Add licensed `.mp3` files under `assets/audio/` if the
  lecturer requires real sound.
- Lab 9 runs in demo mode until `openWeatherApiKey` is replaced with an
  OpenWeatherMap key. Never commit a real key to a public repository.
