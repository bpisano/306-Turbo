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
    
    var sceneName: String {
        switch self {
        case .campagne:
            return "Campagne"
        case .beach:
            return "Beach"
        case .airport:
            return "Airport"
        }
    }
    
    var next: Place {
        switch self {
        case .campagne:
            return .beach
        case .beach:
            return .campagne
        case .airport:
            return .campagne
        }
    }
    
}

enum Time: Int {
    
    case morning
    case afternoon
    case night
    
    var next: Time {
        switch self {
        case .morning:
            return .afternoon
        case .afternoon:
            return .night
        case .night:
            return .morning
        }
    }
    
}

class Configuration: NSObject, NSCoding {
    
    struct shared {
        
        static var currentConfiguration: Configuration?
        
    }
    
    private let numberOfGamePerTime: Int = 3
    
    var place: Place
    var time: Time
    var timeBeforeNextTime: Int
    var wheelFriction: CGFloat
    var boost: CGFloat
    
    // MARK: - Init
    
    override init() {
        place = .campagne
        time = .morning
        timeBeforeNextTime = 0
        wheelFriction = 0.1
        boost = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        place = Place(rawValue: aDecoder.decodeInteger(forKey: "place"))!
        time = Time(rawValue: aDecoder.decodeInteger(forKey: "time"))!
        timeBeforeNextTime = aDecoder.decodeInteger(forKey: "timeBeforeNextTime")
        wheelFriction = aDecoder.decodeObject(forKey: "wheelFriction") as! CGFloat
        boost = aDecoder.decodeObject(forKey: "boost") as! CGFloat
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(place.rawValue, forKey: "place")
        aCoder.encode(time.rawValue, forKey: "time")
        aCoder.encode(timeBeforeNextTime, forKey: "timeBeforeNextTime")
        aCoder.encode(wheelFriction, forKey: "wheelFriction")
        aCoder.encode(boost, forKey: "boost")
    }
    
    // MARK: - Configuration Management
    
    static func createDefaultConfiguration() {
        shared.currentConfiguration = Configuration()
        saveConfiguration()
    }
    
    static func loadConfiguration() {
        if UserDefaults.standard.value(forKey: "gameConfiguration") == nil {
            createDefaultConfiguration()
        }
        
        guard let data = UserDefaults.standard.value(forKey: "gameConfiguration") as? Data else {
            createDefaultConfiguration()
            print("Cannot load configuration")
            return
        }
        
        do {
            let configuration = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Configuration
            shared.currentConfiguration = configuration
        } catch let error {
            createDefaultConfiguration()
            print("Cannot load configuration : " + error.localizedDescription)
        }
    }
    
    static func saveConfiguration() {
        guard let configuration = shared.currentConfiguration else {
            print("No configuration loaded")
            return
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: configuration, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "gameConfiguration")
        } catch let error {
            print("Cannot save configuration : " + error.localizedDescription)
        }
    }
    
    func incrementTime() {
        timeBeforeNextTime += 1
        
        if timeBeforeNextTime == numberOfGamePerTime {
            time = time.next
            timeBeforeNextTime = 0
        }
        
        Configuration.saveConfiguration()
    }
    
}
