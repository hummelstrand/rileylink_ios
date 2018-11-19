//
//  PodAlarm.swift
//  OmniKit
//
//  Created by Pete Schwamb on 10/24/18.
//  Copyright © 2018 Pete Schwamb. All rights reserved.
//

import Foundation

public enum PodAlarm: UInt8, CustomStringConvertible {
    case podExpired      = 0b10000000
    case suspendExpired  = 0b01000000
    case suspended       = 0b00100000
    case lowReservoir    = 0b00010000
    case oneHourExpiry   = 0b00001000
    case podDeactivated  = 0b00000100
    case unknownBit2     = 0b00000010
    case unknownBit1     = 0b00000001
    
    public typealias AllCases = [PodAlarm]
    
    static var allCases: AllCases {
        return (0..<8).map { PodAlarm(rawValue: 1<<$0)! }
    }
    
    public var description: String {
        switch self {
        case .podExpired:
            return LocalizedString("Pod Expired", comment: "Pod alarm when pod expires")
        case .suspendExpired:
            return LocalizedString("Suspend Expired", comment: "Pod alarm when suspend has expired")
        case .suspended:
            return LocalizedString("Suspended", comment: "Pod alarm when pod has suspended")
        case .lowReservoir:
            return LocalizedString("Low Reservoir", comment: "Pod alarm when reservoir is low")
        case .oneHourExpiry:
            return LocalizedString("One Hour Expiry", comment: "Pod alarm for one hour expiry")
        case .podDeactivated:
            return LocalizedString("One Hour Expiry", comment: "Pod alarm for deactivated pod")
        case .unknownBit2:
            return LocalizedString("Unknown Alarm 2", comment: "Pod alarm for unknown bit2")
        case .unknownBit1:
            return LocalizedString("Unknown Alarm 1", comment: "Pod alarm for unknown bit1")
        }
    }
}

public struct PodAlarmState: RawRepresentable, Collection, CustomStringConvertible, Equatable {
    
    public typealias RawValue = UInt8
    public typealias Index = Int
    
    public let startIndex: Int
    public let endIndex: Int
    
    private let elements: [PodAlarm]
    
    public static let none = PodAlarmState(rawValue: 0)
    
    public var rawValue: UInt8 {
        return elements.reduce(0) { $0 | $1.rawValue }
    }
    
    public init(rawValue: UInt8) {
        self.elements = PodAlarm.allCases.filter { rawValue & $0.rawValue != 0 }
        self.startIndex = 0
        self.endIndex = self.elements.count
    }
    
    public subscript(index: Index) -> PodAlarm {
        return elements[index]
    }
    
    public func index(after i: Int) -> Int {
        return i+1
    }
    
    public var description: String {
        if elements.count == 0 {
            return LocalizedString("No alarms", comment: "Pod alarm state when no alarms are activated")
        } else {
            let alarmDescriptions = elements.map { String(describing: $0) }
            return alarmDescriptions.joined(separator: ", ")
        }
    }
}