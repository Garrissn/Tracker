//
//  HelpersFunction.swift
//  Tracker
//
//  Created by Игорь Полунин on 24.08.2023.
//

import Foundation

final class HelpersFunction {
    
     func pluralizeDays(_ count: Int) -> String {
        let localizedCompletedDayz = NSLocalizedString("completedDays", comment: "Number of completed days")
        return String.localizedStringWithFormat(localizedCompletedDayz, count)
    }
    
     func convertIndexPathToString(_ indexPath: IndexPath) -> String {
        
                           return "\(indexPath.section),\(indexPath.row)"
                       }
    
     func convertStringToIndexPath(_ string: String) -> IndexPath? {
        let components = string.components(separatedBy: ",")
        if components.count == 2,
            let section = Int(components[0]),
           let row = Int(components[1]) {
           
            return IndexPath(row: row, section: section)
        }
        return nil
    }
}
