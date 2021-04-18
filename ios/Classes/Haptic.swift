//
//  Haptic.swift
//  haptic_controller
//
//  Created by Jinsu Gu on 2021/04/14.
//

import Foundation
import CoreHaptics
import AudioToolbox

@available(iOS 13.0, *)
class Haptic {
    static var canHaptic: Bool { return CHHapticEngine.capabilitiesForHardware().supportsHaptics }
    
    public static let shared: Haptic = Haptic()
    var _engine: CHHapticEngine?
    
    public static var defaultDuration:Double = 0.1
    public static var defaultIntensity:Double = 1
    
    init() {
        guard Haptic.canHaptic else {
            Log("Not Support Haptic")
            return
        }
        
        do {
            self._engine = try CHHapticEngine()
            try _engine?.start()
            Log("init finished")
        } catch {
            Log("Failed to start : \(error.localizedDescription)")
        }
    }
    
    func haptic() {
        guard Haptic.canHaptic else {
            Log("Not Support Haptic")
            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return
        }
        
        hapticPattern(delayTime: [0], duration: [Haptic.defaultDuration], intensities: [Haptic.defaultIntensity])
    }
        
    func hapticPattern(delayTime:[Double], duration:[Double], intensities:[Double]) {
        do {
            var events = [CHHapticEvent]()
            
            for i in 0..<delayTime.count {
                
                let di = i >= duration.count ? duration.count - 1 : i
                let ii = i >= intensities.count ? intensities.count - 1 : i
                
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(intensities[ii]))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity], relativeTime:delayTime[i], duration: duration[di])
                
                events.append(event)
            }
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try _engine?.makePlayer(with: pattern)
            
            try player?.start(atTime: CHHapticTimeImmediate)
            
        } catch {
            Log("Failed to play : \(error.localizedDescription)")
        }
    }
    
    private func Log(_ str:String) {
        NSLog(str)
        print(str)
    }
}
