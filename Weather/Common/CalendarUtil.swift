//
//  CalendarUtil.swift
//  Weather
//
//  Created by helloyako on 2020/04/17.
//  Copyright © 2020 helloyako. All rights reserved.
//

import Foundation

class CalendarUtil {
    static let shared = CalendarUtil()
    private let weekdayMap: [Int: String]
    private init() {
        let string = "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday"
        let array = string.split(separator: ",").map { String($0) }
        var map: [Int: String] = [:]
        for i in 0..<array.count {
            map[i + 1] = array[i]
        }
           
        weekdayMap = map
    }
    
    func getWeekday(_ timestamp: TimeInterval) -> String {
        guard let utc = TimeZone(identifier: "UTC") else {
            return ""
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = utc
        let date = Date(timeIntervalSince1970: timestamp)
        let weekday = calendar.component(.weekday, from: date)
        return weekdayMap[weekday] ?? ""
    }
}
