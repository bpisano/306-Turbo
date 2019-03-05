//
//  Configuration.swift
//  306 Turbo
//
//  Created by Benjamin Pisano on 05/03/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit

enum Place: Int {
    
    case campagne
    case beach
    case airport
    
}

enum Time: Int {
    
    case day
    case night
    
}

class Configuration: NSObject, NSCoding {
    
    struct shared {
        
        static var currentConfiguration: Configuration?
        
    }
    
    var place: Place
    var time: Time
    var wheelFriction: CGFloat
    var boost: CGFloat
    
    // MARK: - Init
    
    override init() {
        place = .campagne
        time = .day
        wheelFriction = 0.1
        boost = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        place = Place(rawValue: aDecoder.decodeInteger(forKey: "place"))!
        time = Time(rawValue: aDecoder.decodeInteger(forKey: "time"))!
        wheelFriction = aDecoder.value(forKey: "wheelFriction") as! CGFloat
        boost = aDecoder.value(forKey: "boost") as! CGFloat
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(place.rawValue, forKey: "place")
        aCoder.encode(time.rawValue, forKey: "time")
        aCoder.encode(wheelFriction, forKey: "wheelFriction")
        aCoder.encode(boost, forKey: "boost")
    }
    
    // MARK: - Configuration Management
    
    static func loadConfiguration() {
        if UserDefaults.standard.value(forKey: "configuration") == nil {
            shared.currentConfiguration = Configuration()
            saveConfiguration()
        }
        
        guard let data = UserDefaults.standard.value(forKey: "configuration") as? Data else {
            print("Cannot load configuration")
            return
        }
        
        do {
            let configuration = try NSKeyedUnarchiver.unarchivedObject(ofClass: Configuration.self, from: data)
            shared.currentConfiguration = configuration
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func saveConfiguration() {
        guard let configuration = shared.currentConfiguration else {
            print("No configuration loaded")
            return
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: configuration, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "configuration")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
