# V8 Health — SwiftUI App

Full SwiftUI port of the V8 BLE SDK Demo, using iOS 17 MVVM (`@Observable`, no Combine).

## Open in Xcode

1. Open `V8 IOS/app/V8HealthSwiftUI.xcodeproj`
2. Select your **Development Team** in Signing & Capabilities
3. Build and run on a **physical iPhone** (Bluetooth required)

**Requirements:** iOS 17+, iPhone with Bluetooth, V8 wearable device

## Features (all 21 demo screens)

| Section | Screens |
|---------|---------|
| Settings | Device Time, Personal Info, Step Goal, Device Info, Auto Measurement |
| Live Data | Real-time Steps, Activity Mode, ECG |
| History | Activity, Sleep, Heart Rate, Temperature, SpO2, HRV, PPI |
| Other | Alarms, Log Export |

## Architecture

```
Views/          → SwiftUI only (thin UI)
ViewModels/     → @Observable @MainActor, one per screen
Core/
  V8BLEClient   → scan, connect, send, parse (singleton)
  BLECommand    → SDK command wrappers
  HistorySyncHelper → pagination mode 0 / 2 / 0x99
Components/     → SyncLogView, ECGWaveformView, etc.
BLE/            → NewBle + BleDelegateProxy (Obj-C bridge)
BleSDK/         → libBleSDK.a + headers
```

**Pattern:** Each ViewModel subscribes to `V8BLEClient.onParsedResponse` in `onAppear` and clears it in `onDisappear` — same lifecycle as the Obj-C demo’s per-screen delegate.

## Project layout

```
V8HealthSwiftUI/
├── Core/
├── Models/
├── ViewModels/
├── Components/
├── Views/
└── Utilities/
```
