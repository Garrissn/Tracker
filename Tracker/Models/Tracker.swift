//
//  Tracker.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.07.2023.
//


import UIKit

struct Tracker {
    let isPinned: Bool
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
}
