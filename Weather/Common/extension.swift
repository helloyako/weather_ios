//
//  extension.swift
//  Weather
//
//  Created by helloyako on 2020/04/16.
//  Copyright © 2020 helloyako. All rights reserved.
//

import UIKit

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound && range.location == 0 {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

extension Date {
    var display: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

extension Double {
    func toTemperatureDegree(isCelsius: Bool) -> String {
        var degree = self
        if !isCelsius {
            degree = (degree * 9 / 5) + 32
        }
        return "\(Int(degree))°"
    }
}
