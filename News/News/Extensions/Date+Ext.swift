//
//  Date+Ext.swift
//  News
//
//  Created by Furkan Türkyaşar on 1.02.2025.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let now = Date()
        let components = Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year],
            from: self,
            to: now
        )

        if let year = components.year, year > 0 {
            return String(format: NSLocalizedString("%d_years_ago", comment: ""), year)
        } else if let month = components.month, month > 0 {
            return String(format: NSLocalizedString("%d_months_ago", comment: ""), month)
        } else if let week = components.weekOfYear, week > 0 {
            return String(format: NSLocalizedString("%d_weeks_ago", comment: ""), week)
        } else if let day = components.day, day > 0 {
            return String(format: NSLocalizedString("%d_days_ago", comment: ""), day)
        } else if let hour = components.hour, hour > 0 {
            return String(format: NSLocalizedString("%d_hours_ago", comment: ""), hour)
        } else if let minute = components.minute, minute > 0 {
            return String(format: NSLocalizedString("%d_minutes_ago", comment: ""), minute)
        } else {
            return NSLocalizedString("just_now", comment: "")
        }
    }
}
