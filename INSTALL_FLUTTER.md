# Инструкция по установке Flutter на Windows

## 📋 Системные требования

- **ОС:** Windows 10 или новее (64-разрядная)
- **Место на диске:** 2.8 ГБ (без учёта IDE)
- **Инструменты:** PowerShell 5.0+, Git для Windows

---

## 🚀 Шаг 1: Скачивание Flutter SDK

### Вариант А: Прямая загрузка (рекомендуется)

1. Перейдите на официальную страницу: https://docs.flutter.dev/get-started/install
2. Нажмите **"Download Flutter SDK"** для Windows
3. Или прямая ссылка на стабильную версию:
   https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_*.zip

### Вариант Б: Через Git

```bash
# Создайте папку для Flutter
mkdir C:\src
cd C:\src

# Клонируйте репозиторий Flutter
git clone https://github.com/flutter/flutter.git -b stable
```

---

## 🚀 Шаг 2: Распаковка и настройка PATH

### Если скачали ZIP-архив:

1. Распакуйте архив в папку: `C:\src\flutter`
   (Не используйте пути с пробелами и кириллицей!)

2. Добавьте Flutter в системную переменную PATH:

   **Способ 1: Через интерфейс Windows**
   - Нажмите `Win + R` → введите `sysdm.cpl` → Enter
   - Вкладка **"Дополнительно"** → кнопка **"Переменные среды"**
   - В разделе **"Системные переменные"** найдите `Path`
   - Нажмите **"Изменить"** → **"Создать"**
   - Добавьте: `C:\src\flutter\bin`
   - Нажмите **OK** во всех окнах

   **Способ 2: Через PowerShell (от администратора)**
   ```powershell
   [Environment]::SetEnvironmentVariable(
     "Path",
     $env:Path + ";C:\src\flutter\bin",
     "Machine"
   )
   ```

---

## 🚀 Шаг 3: Установка Android Studio

Flutter требует Android SDK для сборки под Android.

### 3.1 Скачивание Android Studio

1. Перейдите: https://developer.android.com/studio
2. Скачайте и установите **Android Studio**
3. При установке отметьте:
   - ✅ Android Virtual Device
   - ✅ Android SDK
   - ✅ Android SDK Platform-tools

### 3.2 Настройка Android SDK

После установки Android Studio:

1. Откройте Android Studio
2. **More Actions** → **SDK Manager**
3. Установите компоненты:
   - Android SDK Platform (последняя версия)
   - Intel x86 Emulator Accelerator (HAXM) — для процессоров Intel
   - Android SDK Build-Tools
   - Android Emulator

### 3.3 Принятие лицензий

Откройте PowerShell от имени администратора:

```bash
flutter doctor --android-licenses
```

Нажмите `y` для принятия всех лицензий.

---

## 🚀 Шаг 4: Установка Visual Studio (для Windows-приложений)

Если хотите запускать приложение на Windows:

1. Скачайте **Visual Studio Community 2022**:
   https://visualstudio.microsoft.com/downloads/

2. При установке выберите workload:
   - ✅ **"Разработка классических приложений на C++"**
   - Компоненты:
     - ✅ MSVC v143 — VS 2022 C++ x64/x86 build tools
     - ✅ Windows 10/11 SDK
     - ✅ CMake tools

---

## 🚀 Шаг 5: Проверка установки

### 5.1 Перезапустите терминал

Закройте и откройте PowerShell заново для применения PATH.

### 5.2 Запустите диагностику

```bash
flutter doctor -v
```

### Ожидаемый результат:

```
[✓] Flutter (Channel stable, 3.x.x, on Windows)
[✓] Windows Version (10/11)
[✓] Android toolchain - develop for Android devices
[✓] Visual Studio - develop Windows apps
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device
[✓] Network resources
```

### Если есть проблемы:

| Проблема | Решение |
|----------|---------|
| `Android license status unknown` | Запустите `flutter doctor --android-licenses` |
| `Unable to locate Android Studio` | Установите через официальный установщик |
| `cmdline-tools component is missing` | В Android Studio: SDK Manager → SDK Tools → Android SDK Command-line Tools |

---

## 🚀 Шаг 6: Запуск приложения CleanBack

### 6.1 Перейдите в папку проекта

```bash
cd C:\Users\Митя\Documents\Projects\clb-app
```

### 6.2 Установите зависимости

```bash
flutter pub get
```

### 6.3 Запустите приложение

**Вариант А: Эмулятор Android**
```bash
# Запустить эмулятор
flutter emulators

# Выбрать и запустить
flutter emulators --launch <emulator_id>

# Запустить приложение
flutter run
```

**Вариант Б: Chrome (быстрый тест)**
```bash
flutter run -d chrome
```

**Вариант В: Windows (десктоп)**
```bash
flutter run -d windows
```

---

## 🔧 Дополнительные команды

### Обновление Flutter
```bash
flutter upgrade
```

### Очистка проекта
```bash
flutter clean
flutter pub get
```

### Сборка APK
```bash
flutter build apk --release
```

### Сборка для Windows
```bash
flutter build windows --release
```

### Запуск тестов
```bash
flutter test
```

---

## ⚡ Быстрая установка (скрипт)

Сохраните как `install-flutter.ps1` и запустите от администратора:

```powershell
# Создать папку
New-Item -ItemType Directory -Force -Path C:\src

# Скачать Flutter (замените версию на актуальную)
$url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip"
$output = "C:\src\flutter.zip"
Invoke-WebRequest -Uri $url -OutFile $output

# Распаковать
Expand-Archive -Path $output -DestinationPath C:\src -Force
Remove-Item $output

# Добавить в PATH
$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$newPath = "$oldPath;C:\src\flutter\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

Write-Host "Flutter установлен! Перезапустите терминал и выполните: flutter doctor"
```

---

## 📞 Полезные ссылки

- Официальная документация: https://docs.flutter.dev
- Flutter Cookbook: https://docs.flutter.dev/cookbook
- Pub.dev (пакеты): https://pub.dev
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
