//
//  DateFromatter+Extension.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/28.
//

import Foundation

extension DateFormatter {
    static let format = {
        let format = DateFormatter()
        format.dateFormat = "yy년 MM월 dd일"
        return format
    }()
    
    static func today() -> String {
        return format.string(from: Date())
    }
    
    static func convertDate(date: Date) -> String {
        return format.string(from:date)
    }
    
    static func getYearMonth(date: Date) -> String{
        let format = DateFormatter()
        format.dateFormat = "yyyy년 M월"
        return format.string(from: date)
    }
    
    static func getMonthDayWeekDay(date: Date) -> String{
        let format = DateFormatter()
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