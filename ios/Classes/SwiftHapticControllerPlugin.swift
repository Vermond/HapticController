import Flutter
import UIKit

@available(iOS 13.0, *)
public class SwiftHapticControllerPlugin: NSObject, FlutterPlugin {
    
    private static let haptic:Haptic = Haptic()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "haptic_controller", binaryMessenger: registrar.messenger())
        let instance = SwiftHapticControllerPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "canHaptic":
            result(Haptic.canHaptic)
            break
        case "hapticTime":
            if let args = call.arguments as? [String:NSNumber],
                let value = args["set"]{
                Haptic.hapticDuration = Double(truncating: value)
                result(true)
                break
            } else {
                result(Haptic.hapticDuration)
                break
            }
        case "hapticIntensity":
            if let args = call.arguments as? [String:NSNumber],
                let value = args["set"]{
                Haptic.hapticIntensity = Double(truncating: value)
                result(true)
                break
            } else {
                result(Haptic.hapticIntensity)
                break
            }
        case "haptic":
            SwiftHapticControllerPlugin.haptic.haptic()
            result(true)
            break
        case "hapticPattern":
            guard let args = call.arguments as? [String:FlutterStandardTypedData],
                  let delayTime = makeDoubleArray(args["delayTime"]),
                  let intensities = makeDoubleArray(args["intensities"]),
                  let duration = makeDoubleArray(args["duration"]) else {
                result(FlutterError(code: call.method, message: "wrong arguments or nil", details: nil))
                break
            }
            
            SwiftHapticControllerPlugin.haptic.hapticPattern(delayTime: delayTime, duration: duration, intensities: intensities)
            result(true)
            break
        default:
            result(false)
        }
    }
}

@available(iOS 13.0, *)
extension SwiftHapticControllerPlugin {
    
    func makeDoubleArray(_ data:FlutterStandardTypedData?) -> [Double]? {
        guard data != nil && data!.type == FlutterStandardDataType.float64 else {
            return nil
        }
        
        return makeArray([UInt8](data!.data))
    }
    
    private func makeArray(_ bytes:[UInt8]) -> [Double]? {
        let size = MemoryLayout<Double>.size
        
        guard bytes.count % size == 0 else {
            return nil
        }
        
        var array:[Double] = []
        
        for index in stride(from: 0, to: bytes.count, by: size) {
            array.append(Double(Array(bytes[index..<index + size])) ?? 0)
        }
        
        return array
    }
}

extension FloatingPoint {
    init?(_ bytes: [UInt8]) {
        guard bytes.count == MemoryLayout<Self>.size else { return nil }
        self = bytes.withUnsafeBytes {
            return $0.load(fromByteOffset: 0, as: Self.self)
        }
    }
    
}
