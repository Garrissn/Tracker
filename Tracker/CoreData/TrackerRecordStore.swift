//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Игорь Полунин on 30.07.2023.
//

import Foundation
import CoreData

protocol TrackerRecordStoreProtocol {
    func recordExists(forId: UUID, date: String) -> Bool
    func numberOfRecords(forId: UUID) -> Int
    func addRecord(forId: UUID, date: String) throws
    func deleteRecord(forId: UUID, date: String) throws
    
}

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    func recordExists(forId: UUID, date: String) -> Bool {
        let request = NSFetchRequest<TrackerRecordEntity>(entityName: "TrackerRecordEntity")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordEntity.trackerRecordID), forId.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordEntity.date), date)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate,datePredicate])
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    func numberOfRecords(forId: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordEntity>(entityName: "TrackerRecordEntity")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordEntity.trackerRecordID), forId.uuidString)
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }
    
    func addRecord(forId: UUID, date: String) throws {
        let newTrackerRecord = TrackerRecordEntity(context: context)
        newTrackerRecord.trackerRecordID = forId.uuidString
        newTrackerRecord.date = date
        try context.save()
    }
    
    func deleteRecord(forId: UUID, date: String) throws {
        let request = NSFetchRequest<TrackerRecordEntity>(entityName: "TrackerRecordEntity")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordEntity.trackerRecordID), forId.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordEntity.date), date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate,datePredicate])
        guard let trackerRecord = try context.fetch(request).first  else { return }
        context.delete(trackerRecord)
        try context.save()
    }
    
   
}
