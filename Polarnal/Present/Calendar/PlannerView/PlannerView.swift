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
