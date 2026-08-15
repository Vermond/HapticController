# HapticController

Flutter에서 Android/iOS 네이티브 기능을 호출하는 방법을 검증하기 위해 만든 햅틱 제어 플러그인 예제입니다.

당시 사내 Flutter 프로젝트에서 네이티브 브리징 구조를 설명하고 공유하기 위한 목적으로 제작했으며, Flutter의 `MethodChannel`을 통해 Dart 코드와 각 플랫폼의 네이티브 구현을 연결합니다.

## 주요 구성

### Flutter

Dart 영역에서는 공통 API를 제공하고 `MethodChannel`을 통해 네이티브 구현을 호출합니다.

지원하는 기능은 다음과 같습니다.

* 햅틱 지원 여부 확인
* 햅틱 지속 시간 설정
* 햅틱 강도 설정
* 단일 햅틱 실행
* 지연 시간, 지속 시간, 강도를 조합한 햅틱 패턴 실행

### iOS

iOS에서는 Swift와 `CoreHaptics`를 사용합니다.

* `CHHapticEngine`
* `CHHapticEvent`
* `CHHapticPattern`

Flutter에서 전달받은 패턴 데이터를 네이티브 배열로 변환한 뒤 Core Haptics를 통해 실행합니다.

### Android

Android에서는 Kotlin과 `Vibrator` / `VibrationEffect`를 사용합니다.

* Android 8.0(API 26) 이상에서는 `VibrationEffect`
* 이전 버전에서는 기존 `Vibrator` API

플랫폼 버전에 따라 다른 햅틱 구현을 사용하도록 구성했습니다.

## 구조

```text
Flutter / Dart
    ↓
MethodChannel
    ↓
Platform Plugin
    ├─ Android / Kotlin
    └─ iOS / Swift
        ↓
Native Haptic API
```

주요 파일:

```text
lib/
└─ haptic_controller.dart

android/src/main/kotlin/com/victor/haptic_controller/
├─ HapticControllerPlugin.kt
└─ Haptic.kt

ios/Classes/
├─ SwiftHapticControllerPlugin.swift
└─ Haptic.swift

example/
└─ lib/main.dart
```

## Example

`example` 프로젝트에서는 다음 기능을 직접 실행해볼 수 있습니다.

* 기기의 햅틱 지원 여부 확인
* 단일 햅틱 실행
* 여러 개의 햅틱 이벤트로 구성된 패턴 실행

## 제작 목적

이 프로젝트는 범용 햅틱 라이브러리를 새로 배포하거나 기존 Flutter 패키지를 대체하기 위한 목적으로 만든 것은 아닙니다.

사내 프로젝트에서 Flutter와 Android/iOS 네이티브 코드 사이의 브리징 방법을 검증하고, 관련 구현 예제를 제공하기 위해 제작했습니다.

당시 이미 pub.dev에 햅틱 기능을 제공하는 패키지들이 존재했기 때문에, 브리징 예제로서의 목적을 달성한 이후에는 별도의 범용 라이브러리로 확장하지 않았습니다.

## 개발 시점

2021년 Flutter 환경을 기준으로 작성된 예제이며, 현재 Flutter SDK 및 각 플랫폼 API 기준으로 별도의 현대화 작업은 진행하지 않았습니다.

## 한계 및 범위

이 프로젝트는 Flutter와 Android/iOS 네이티브 코드 사이의 브리징 구조를 검증하기 위한 예제로 제작되었기 때문에, 범용 라이브러리 수준의 완성도를 목표로 하지는 않았습니다.

따라서 다음 항목은 구현 범위에 포함하지 않았습니다.

* 다양한 입력값과 예외 상황에 대한 세밀한 검증
* 충분한 자동화 테스트
* 범용 패키지 배포를 위한 API 안정화 및 문서화
* 실제 서비스 수준의 예제 애플리케이션 구성
* 이후 Flutter SDK 및 Android/iOS API 변화에 대한 지속적인 업데이트

또한 햅틱 기능 자체는 당시에도 pub.dev에서 기존 패키지를 통해 사용할 수 있었기 때문에, 브리징 예제로서의 목적을 달성한 이후 별도의 범용 패키지로 확장하거나 유지보수하지 않았습니다.

