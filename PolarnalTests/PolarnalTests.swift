//
//  PolarnalTests.swift
//  PolarnalTests
//
//  Created by 최승범 on 2/19/25.
//

import XCTest

final class DateManagerTest: XCTestCase {
    
    private let dateManager = DateManager.shared
    
    // 년 월 일이 똑바로 나오는지 테스트
    //getYearAndMonthString 테스트
    private func test_getYearAndMonthString() throws {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 17
        let settingDate = calendar.date(from: components)!
        
        let ymd = dateManager.getYearAndMonthString(currentDate: settingDate)
        
        XCTAssertEqual(ymd, ["2024", "02", "17"])
        
    }
    
    // getDateString 테스트
    private func test_getDateString() throws {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 17
        let settingDate = calendar.date(from: components)!
        
        let dateString = dateManager.getDateString(date: settingDate)
        
        XCTAssertEqual(dateString, "2024.02.17")
    }
    
    private func test_getDateString_format() throws {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 17
        let settingDate = calendar.date(from: components)!
        
        let dateString = dateManager.getDateString(format: "YYYY-MM-dd",date: settingDate)
        
        
        XCTAssertEqual(dateString, "2024-02-17")
    }
    
    // D-Day 계산 테스트
    
    
}
