//
//  String+Ext.swift
//  News
//
//  Created by Furkan Türkyaşar on 1.02.2025.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: self)
    }
}
