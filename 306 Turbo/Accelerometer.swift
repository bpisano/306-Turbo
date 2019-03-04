//
//  Accelerometer.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 04/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit
import CoreMotion

typealias AccelerometerUpdate = (_ rotation: CGFloat) -> Void

class Accelerometer: NSObject {
    
    var motionManager = CMMotionManager()
    
    func start(completion: @escaping AccelerometerUpdate) {
        guard motionManager.isDeviceMotionAvailable && !motionManager.isDeviceMotionActive else {
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            completion(CGFloat(data.attitude.yaw))
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
    
}
