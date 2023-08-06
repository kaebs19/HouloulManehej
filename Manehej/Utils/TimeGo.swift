//
//  TimeGo.swift
//  Manehej
//
//  Created by pommestore on 20/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation
func DateText(date: String) -> String {
    
    
    let isoDate = date
    if (!isoDate.contains("T")){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        let created_at = relativePast(for: finalDate!)
        return created_at
    }
    else{
        var isoDate = isoDate.substring(from:0, toSubstring:".00")
        let isoDate1 = isoDate?.description.replacingOccurrences(of: "T", with: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:isoDate1!)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        let created_at = relativePast(for: finalDate!)
        return created_at
        
    }
}

func relativePast(for date : Date) -> String {
    
    let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
    let components = Calendar.current.dateComponents(units, from: date, to: Date())
    
    if components.year! > 0 {
        return "\(components.year!) " + (components.year! > 1 ? " سنين مضت " : "منذ عام")
        
    } else if components.month! > 0 {
        return "\(components.month!) " + (components.month! > 1 ? "منذ اشهر" : "منذ شهر")
        
    } else if components.weekOfYear! > 0 {
        return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "منذ أسابيع" : "منذ أسبوع")
        
    } else if (components.day! > 0) {
        return (components.day! > 1 ? "\(components.day!) أيام مضت" : "في الامس")
        
    } else if components.hour! > 0 {
        return "\(components.hour!) " + (components.hour! > 1 ? "منذ ساعات" : "منذ ساعة")
        
    } else if components.minute! > 0 {
        return "\(components.minute!) " + (components.minute! > 1 ? "دقائق مضت" : "منذ دقيقة")
        
    } else {
        return "\(components.second!) " + (components.second! > 1 ? "منذ ثوانى" : "قبل ثانية")
    }
}
extension String {
    func substring(from:Int, toSubstring s2 : String) -> Substring? {
        guard let r = self.range(of:s2) else {return nil}
        var s = self.prefix(upTo:r.lowerBound)
        s = s.dropFirst(from)
        return s
    }
}
