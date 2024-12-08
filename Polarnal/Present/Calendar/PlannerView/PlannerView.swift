//
//  PlannerView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI

struct PlannerView: View {
//    @Environment(\.modelContext) private var modelContext
   
    var body: some View {
        NavigationSplitView {
            HStack {
                SideTabBarView()
                    .frame(width: 80)
                
                CalendarListView()
            }
        } detail: {
            Text("달력")
        }

    }
    
}

#Preview {
    PlannerView()
}

struct CalendarListView: View {
    var body: some View {
        VStack {
            List {
                
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: .infinity)
                    .frame(height: 240)
                CalendarView()
            }
            
        }
    }
    
    func calendarCell() {
        
    }
}


struct CalendarView: View {
    var currentDate: Date = Date()

    private let dateFormatter = DateFormatter()
    
    var body: some View {
        Text("\(getYearAndMonthString(currentDate: currentDate))")
    }
    
    /// 현재 연도, 월 String으로 변경하는 formatter로 배열 구하는 함수
    func getYearAndMonthString(currentDate: Date) -> [String] {
        
        dateFormatter.dateFormat = "YYYY MMMM"
        dateFormatter.locale = Locale(identifier: "ko_kr")
            
        let date = dateFormatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
}
