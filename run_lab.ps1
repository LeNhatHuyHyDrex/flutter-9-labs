# Run any of the 9 Flutter labs on the Android emulator
#
# Usage:
#   .\run_lab.ps1 1              -> run lab 1 on the emulator
#   .\run_lab.ps1 3 -Clean       -> clean build artifacts first, then run
#   .\run_lab.ps1 9 -Build       -> only build the debug APK
#   .\run_lab.ps1 6 -Device emulator-5554
#   .\run_lab.ps1 1 -Doctor      -> run flutter doctor
#
# NOTE: keep this file ASCII-only. PowerShell 5.1 reads .ps1 as ANSI,
# so non-ASCII characters (Vietnamese, smart quotes) break parsing.

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateRange(1, 9)]
    [int]$Lab,

    [switch]$Build,
    [switch]$Clean,
    [switch]$Doctor,
    [string]$Device = "emulator-5554"
)

$ErrorActionPreference = "Stop"

$Root    = "D:\code\Nam_4_ki1\DiDongDaNenTang\lab\flutter-9-labs"
$Flutter = "C:\Users\ASUS\flutter\bin\flutter.bat"
$Sdk     = "C:\Users\ASUS\AppData\Local\Android\sdk"

# Gradle needs Java 17 or 21. Point JAVA_HOME at Android Studio's JBR.
# IMPORTANT: pass the SHORT path (C:\PROGRA~1\...) to JAVA_HOME. Java's launcher
# cannot resolve an 8.3 short name with a space in the expanded path and fails with
#   "Could not find or load main class Files\Android\Android"
# Do NOT also set -Dorg.gradle.java.home: it re-introduces the same short-path bug.
$Jbr = "C:\PROGRA~1\Android\ANDROI~1\jbr"
if (-not (Test-Path $Jbr)) {
    # Fall back to the long path if the short name is not available.
    $Jbr = "C:\Program Files\Android\Android Studio\jbr"
}

$env:JAVA_HOME = $Jbr
$env:ANDROID_HOME = $Sdk
$env:ANDROID_SDK_ROOT = $Sdk
$env:Path = "$Jbr\bin;$Sdk\platform-tools;$Sdk\emulator;C:\Program Files\Git\cmd;$env:Path"

if (-not (Test-Path $Flutter)) {
    throw "Flutter not found at $Flutter  -- edit the `$Flutter variable in this script."
}

$names = @{
    1 = "lab_01_i_am_rich"
    2 = "lab_02_micard"
    3 = "lab_03_dice"
    4 = "lab_04_magic_8_ball"
    5 = "lab_05_xylophone"
    6 = "lab_06_quizzler"
    7 = "lab_07_destini"
    8 = "lab_08_bmi_calculator"
    9 = "lab_09_clima"
}

$project = Join-Path $Root $names[$Lab]
if (-not (Test-Path $project)) {
    throw "Project not found: $project"
}

Set-Location $project
Write-Host "=== Lab $Lab : $($names[$Lab])" -ForegroundColor Cyan
Write-Host "JAVA_HOME = $env:JAVA_HOME"
Write-Host "Project   = $project"

if ($Doctor) {
    & $Flutter doctor -v
    return
}

if ($Clean) {
    Write-Host "--- flutter clean" -ForegroundColor Yellow
    & $Flutter clean
    Remove-Item -Recurse -Force (Join-Path $project "android\.gradle") -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force (Join-Path $project "android\build")    -ErrorAction SilentlyContinue
}

# Make sure local.properties points at the SDK + Flutter SDK.
$localProps = Join-Path $project "android\local.properties"
$flutterSdk = Split-Path (Split-Path $Flutter -Parent) -Parent
$sdkEscaped  = $Sdk     -replace '\\', '\\'
$fsEscaped   = $flutterSdk -replace '\\', '\\'

if (-not (Test-Path $localProps)) {
    Write-Host "--- creating local.properties" -ForegroundColor Yellow
    @(
        "sdk.dir=$sdkEscaped",
        "flutter.sdk=$fsEscaped"
    ) | Set-Content -Path $localProps -Encoding ASCII
}

# Sanity check: the Kotlin DSL files must exist, and gradle.properties must keep
# android.newDsl / android.builtInKotlin (Flutter re-appends them if missing).
$settingsKts = Join-Path $project "android\settings.gradle.kts"
$settingsGr  = Join-Path $project "android\settings.gradle"
if (-not (Test-Path $settingsKts)) {
    throw "Missing android\settings.gradle.kts in $project. Run restore_kotlin_dsl.py first."
}
if (Test-Path $settingsGr) {
    throw "Found android\settings.gradle (Groovy). It shadows the .kts file. Delete it."
}

$propsFile = Join-Path $project "android\gradle.properties"
$propsText = Get-Content -Raw $propsFile
foreach ($flag in @("android.newDsl", "android.builtInKotlin")) {
    if ($propsText -notmatch [regex]::Escape($flag)) {
        Write-Host "NOTE: $flag is missing in gradle.properties - Flutter will re-add it." -ForegroundColor Yellow
    }
}

# Guard: org.gradle.java.home must NOT be set in gradle.properties.
# When it is, gradlew.bat resolves the JBR path through the 8.3 short name
# (C:\PROGRA~1\Android\ANDROI~1\jbr) and appends a forward slash, which makes
# Java's launcher split the path on the space and fail with:
#   "Error: Could not find or load main class Files\Android\Android"
# The working reference project (thu_nghiem) does NOT set this key - a plain
# JAVA_HOME is enough. Detect and strip it.
if ($propsText -match "(?m)^\s*org\.gradle\.java\.home\s*=") {
    Write-Host "NOTE: removing org.gradle.java.home from gradle.properties" -ForegroundColor Yellow
    Write-Host "      (it breaks the Java launcher via the PROGRA~1 short path)." -ForegroundColor Yellow
    $clean = ($propsText -split "`r?`n" |
              Where-Object { $_ -notmatch "^\s*org\.gradle\.java\.home\s*=" }) -join "`r`n"
    [System.IO.File]::WriteAllText($propsFile, $clean, (New-Object System.Text.UTF8Encoding $false))
}

# Guard: the Flutter SDK's own Gradle plugin build file must be intact.
# If it got corrupted (e.g. a stray Byte-Order-Mark), Gradle reports
#   "Unresolved reference 'plugins'" in flutter_tools/gradle/build.gradle.kts
# and every build fails. Detect it early with a clear message.
$flutterPluginBuild = Join-Path $flutterSdk "packages\flutter_tools\gradle\build.gradle.kts"
if (Test-Path $flutterPluginBuild) {
    $head = [System.IO.File]::ReadAllBytes($flutterPluginBuild)[0..2]
    if ($head[0] -eq 0xEF -and $head[1] -eq 0xBB -and $head[2] -eq 0xBF) {
        throw @"
Flutter SDK is corrupted: $flutterPluginBuild starts with a UTF-8 BOM.
Fix it by running:  cd $flutterSdk ; git checkout -- packages/flutter_tools/gradle/
"@
    }
}

# Guard: the Kotlin Gradle Plugin must be >= 2.3.20, otherwise Flutter's
# DependencyVersionChecker prints this at ERROR level (so it shows up RED in
# Android Studio even though the build still succeeds):
#   "Warning: Flutter support for your project's Kotlin version (2.2.20) will
#    soon be dropped. Please upgrade ... to at least 2.3.20 soon."
# Verified working here: Kotlin 2.3.20 with Gradle 9.1.0 + AGP 9.0.1.
$settingsKtsFile = Join-Path $project "android\settings.gradle.kts"
if (Test-Path $settingsKtsFile) {
    $stext = Get-Content -Raw $settingsKtsFile
    if ($stext -match 'kotlin\.android"\)\s+version\s+"([0-9]+\.[0-9]+\.[0-9]+)"') {
        $kgp = $Matches[1]
        $parts = $kgp.Split(".")
        $minor = [int]$parts[1]
        if ($minor -lt 3) {
            Write-Host "WARNING: Kotlin $kgp is below 2.3.20 - Android Studio will show a RED" -ForegroundColor Yellow
            Write-Host "         'will soon be dropped' warning (harmless but noisy)." -ForegroundColor Yellow
            Write-Host "         Fix: set it to 2.3.20 in android\settings.gradle.kts." -ForegroundColor Yellow
        }
    }
}

# Guard: Gradle 9.3.1 is broken on this machine - its Kotlin DSL script compiler
# cannot resolve even 'println', so any settings.gradle.kts fails with
# "Unresolved reference 'run'/'file'/'id'". Gradle 9.1.0 works. Keep the wrapper
# pinned to 9.1.0 and warn if someone bumps it back.
$wrapperProps = Join-Path $project "android\gradle\wrapper\gradle-wrapper.properties"
if (Test-Path $wrapperProps) {
    $wtext = Get-Content -Raw $wrapperProps
    if ($wtext -match "gradle-9\.3\.") {
        Write-Host "WARNING: wrapper points at Gradle 9.3.x which is broken on this machine." -ForegroundColor Yellow
        Write-Host "         Change it to gradle-9.1.0-all.zip, or run restore_kotlin_dsl.py." -ForegroundColor Yellow
    }
}

Write-Host "--- flutter pub get" -ForegroundColor Yellow
& $Flutter pub get

if ($Build) {
    Write-Host "--- flutter build apk --debug" -ForegroundColor Yellow
    & $Flutter build apk --debug
    $apk = Join-Path $project "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apk) {
        $mb = (Get-Item $apk).Length / 1MB
        Write-Host "APK OK: $apk" -ForegroundColor Green
        Write-Host ("Size: {0:N1} MB" -f $mb)
    } else {
        Write-Host "APK was NOT created" -ForegroundColor Red
    }
    return
}

# Warn early if the emulator is not running.
$devices = (& $Flutter devices) 2>&1 | Out-String
if ($devices -notmatch [regex]::Escape($Device)) {
    Write-Host ""
    Write-Host "WARNING: device '$Device' not found in 'flutter devices'." -ForegroundColor Yellow
    Write-Host "Start an emulator first, e.g.:" -ForegroundColor Yellow
    Write-Host "  flutter emulators --launch <emulator_id>" -ForegroundColor Yellow
    Write-Host "or open Android Studio > Device Manager > Play." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "--- flutter run -d $Device" -ForegroundColor Yellow
& $Flutter run -d $Device
