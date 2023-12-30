//
//  DateFromatter+Extension.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/28.
//

import Foundation

extension DateFormatter {
  
    
    static func todayString() -> String {
        let format = DateFormatter()
        format.dateFormat = "yy년 MM월 dd일"
        return format.string(from: Date())
    }
    
    static func convertFromDateToString(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from:date)
    }
    
    static func convertFromDateToDiaryString(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "MM/dd"
        return format.string(from:date)
    }
    
    static func convertFromStringToDate(date: String) -> Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.date(from:date)
    }
    static func convertToOnlyDateDBForm(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from:date)
    }
    
    static func getYearMonth(date: Date) -> String{
        let format = DateFormatter()
        format.dateFormat = "yyyy년 M월"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        return format.string(from: date)
    }
    static func getYear(date: Date) -> String{
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        return format.string(from: date)
    }
    static func getStartOfYear(year: Int) -> Date{
        let startDayString = "\(year)년 1월 1일"
        let format = DateFormatter()
        format.dateFormat = "yyyy년 M월 dd일"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        return format.date(from: startDayString) ?? Date()
    }
    static func islastDayOfThisYesr()->Bool{
        let now = Calendar.current.startOfDay(for: Date())
        let thisyear = DateFormatter.getYear(date: Date())
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        
        let lastDay = format.date(from: "\(thisyear)-12-31 00:00:00") ?? Date()
        if now == lastDay{
            print(now)
            print(lastDay)
            return true
        }else {
            print(now)
            print(lastDay)
            return false
        }
    }
    static func getMonthDayWeekDay(date: Date) -> String{
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        let weekDay = getKoreanWeekDay(from: date)
        format.dateFormat = "M월 dd일 \(weekDay)요일"
        return format.string(from: date)
    }
    
    static func getKoreanWeekDay(from date: Date) -> String {
        let currentDay = Calendar.current.component(.weekday, from: date)
        switch currentDay {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return "일"
        }
    }
    

}
