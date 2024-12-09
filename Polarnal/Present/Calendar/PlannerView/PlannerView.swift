//
//  PlannerView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI

struct PlannerView: View {
    
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    SideTabBarView()
                        .frame(width: 70)
                    
                    CalendarListView()
                }
                
                CalendarView()
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .offset(CGSize(width: 0, height: 20.0))
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
        List {
            
        }
    }
    
    func calendarCell() {
        
    }
}
