//
//  V8BLEClient.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation
import CoreBluetooth

enum BLEClientError: LocalizedError {
    case notConnected

    var errorDescription: String? {
        switch self {
        case .notConnected: return "Device not connected"
        }
    }
}

@MainActor
@Observable
final class V8BLEClient {
    static let shared = V8BLEClient()

    var connection = ConnectionState()
    var scannedDevices: [ScannedDevice] = []
    var lastMessage = ""

    var onParsedResponse: ((ParsedDeviceResponse) -> Void)?

    private let ble: NewBle = NewBle.sharedManager()!
    private let sdk: BleSDK_V8 = BleSDK_V8.sharedManager()!
    private let proxy: BleDelegateProxy = BleDelegateProxy.shared()

    private init() {
        setupDelegates()
        ble.setUpCentralManager()
    }

    var isReady: Bool { connection.isReady }

    private func setupDelegates() {
        proxy.onConnectSuccessfully = { [weak self] in
            Task { @MainActor in
                self?.connection.status = "Connecting…"
                AppLogger.info("BLE connecting", context: "BLE")
            }
        }
        proxy.onEnableCommunicate = { [weak self] in
            Task { @MainActor in
                guard let self else { return }
                self.connection.isConnected = true
                self.connection.isReady = true
                self.connection.status = "Connected"
                self.lastMessage = "Device ready"
                AppLogger.info("BLE ready for communication", context: "BLE")
            }
        }
        proxy.onDisconnect = { [weak self] error in
            Task { @MainActor in
                self?.resetConnectionState(status: "Disconnected")
                AppLogger.warning(
                    "BLE disconnected",
                    context: "BLE",
                    metadata: ["error": error?.localizedDescription]
                )
            }
        }
        proxy.onConnectFailed = { [weak self] error in
            Task { @MainActor in
                self?.resetConnectionState(status: "Connection failed")
                AppLogger.error(
                    "BLE connection failed",
                    context: "BLE",
                    metadata: ["error": error?.localizedDescription]
                )
            }
        }
        proxy.onScan = { [weak self] peripheral, _, rssi in
            guard let self else { return }
            let value = rssi.intValue
            guard value < 0, value >= -90, let name = peripheral.name, !name.isEmpty else { return }
            Task { @MainActor in
                let device = ScannedDevice(id: peripheral.identifier, name: name, rssi: value, peripheral: peripheral)
                if let index = self.scannedDevices.firstIndex(where: { $0.id == device.id }) {
                    self.scannedDevices[index] = device
                } else {
                    self.scannedDevices.append(device)
                }
            }
        }
        proxy.onData = { [weak self] _, data in
            guard let self else { return }
            Task { @MainActor in self.handleIncomingData(data) }
        }
        ble.delegate = proxy
    }

    private func resetConnectionState(status: String) {
        connection.isConnected = false
        connection.isReady = false
        connection.status = status
    }

    func startScan() {
        AppLogger.debug("BLE scan started", context: "BLE")
        scannedDevices.removeAll()
        connection.isScanning = true
        connection.status = "Scanning…"

        let serviceUUID = CBUUID(string: BLEConstants.service)
        let connected = ble.retrieveConnectedPeripherals(withServices: [serviceUUID]) as? [CBPeripheral] ?? []
        for peripheral in connected {
            let device = ScannedDevice(
                id: peripheral.identifier,
                name: peripheral.name ?? "Device",
                rssi: 0,
                peripheral: peripheral
            )
            scannedDevices.append(device)
        }
        ble.startScanning(withServices: nil)
    }

    func stopScan() {
        ble.stopscan()
        connection.isScanning = false
    }

    func connect(to device: ScannedDevice) {
        stopScan()
        connection.status = "Connecting to \(device.name)…"
        AppLogger.info(
            "BLE connecting to device",
            context: "BLE",
            metadata: ["name": device.name, "rssi": device.rssi]
        )
        ble.connectDevice(device.peripheral)
    }

    func disconnect() {
        AppLogger.info("BLE disconnect requested", context: "BLE")
        ble.disconnect()
        resetConnectionState(status: "Disconnected")
    }

    func send(_ data: Data?) throws {
        guard connection.isReady, let data, let peripheral = ble.activityPeripheral else {
            AppLogger.warning("BLE send skipped — not connected", context: "BLE")
            throw BLEClientError.notConnected
        }
        AppLogger.debug(
            "BLE command sent",
            context: "BLE",
            metadata: ["bytes": data.count, "peripheral": peripheral.name ?? "unknown"]
        )
        ble.writeValue(
            BLEConstants.service,
            characteristicUUID: BLEConstants.sendChar,
            p: peripheral,
            data: data
        )
    }

    func sendAll(_ packets: [Data]) throws {
        for packet in packets {
            try send(packet)
        }
    }

    func parse(_ data: Data) -> ParsedDeviceResponse? {
        guard let parsed = sdk.dataParsing(with: data) else { return nil }
        return ParsedDeviceResponse(
            dataType: SDKDataType(raw: parsed.dataType.rawValue),
            rawDataType: parsed.dataType.rawValue,
            dictionary: parsed.dicData as? [String: Any] ?? [:],
            isEnd: parsed.dataEnd
        )
    }

    private func handleIncomingData(_ data: Data) {
        guard let response = parse(data) else {
            AppLogger.warning("BLE parse failed", context: "BLE", metadata: ["bytes": data.count])
            return
        }
        AppLogger.logParsedResponse(response)
        DeviceEventMonitor.shared.handle(response)
        onParsedResponse?(response)
    }
}
