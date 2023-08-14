//
//  Models.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.07.2023.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday,tuesday,wednesday,thursday,friday,saturday,sunday
    var numberValue: Int {
        switch self {
            
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
    
    var stringValue: String {
        switch self {
        case .monday: return WeekDayLocalize.monday
        case .tuesday: return WeekDayLocalize.tuesday
        case .wednesday: return WeekDayLocalize.wednesday
        case .thursday: return WeekDayLocalize.thursday
        case .friday: return WeekDayLocalize.friday
        case .saturday: return WeekDayLocalize.saturday
        case .sunday: return WeekDayLocalize.sunday
        }
    }
    
    var shortValue: String {
        switch self {
        case .monday: return WeekDayLocalize.mon
        case .tuesday: return WeekDayLocalize.tue
        case .wednesday: return WeekDayLocalize.wed
        case .thursday: return WeekDayLocalize.thu
        case .friday: return WeekDayLocalize.fri
        case .saturday: return WeekDayLocalize.sat
        case .sunday: return WeekDayLocalize.sun
        }
    }
}

private enum WeekDayLocalize {
    static let monday = NSLocalizedString("monday", comment: "MondayTitle")
    static let tuesday = NSLocalizedString("tuesday", comment: "tuesdayTitle")
    static let wednesday = NSLocalizedString("wednesday", comment: "wednesdayTitle")
    static let thursday = NSLocalizedString("thursday", comment: "thursdayTitle")
    static let friday = NSLocalizedString("friday", comment: "fridayTitle")
    static let saturday = NSLocalizedString("saturday", comment: "saturdayTitle")
    static let sunday = NSLocalizedString("sunday", comment: "sundayTitle")
    
    static let mon = NSLocalizedString("mon", comment: "monTitle")
    static let tue = NSLocalizedString("tue", comment: "tueTitle")
    static let wed = NSLocalizedString("wed", comment: "wedTitle")
    static let thu = NSLocalizedString("thu", comment: "thuTitle")
    static let fri = NSLocalizedString("fri", comment: "friTitle")
    static let sat = NSLocalizedString("sat", comment: "satTitle")
    static let sun = NSLocalizedString("sun", comment: "sunTitle")
}
