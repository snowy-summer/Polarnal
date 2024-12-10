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
                    SideTabBarView(viewModel: SideTabBarViewModel())
                        .frame(width: 70)
                    
                    VStack {
                        CalendarEventListView()
                        
                        Divider()
                        
                        CalendarListView()
                    }
                }
                
                Divider()
                
                MiniCalendarView()
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        } detail: {
            MainCalendarView()
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // 일정 추가
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        
    }
    
}

#Preview {
    PlannerView()
}

struct CalendarEventListView: View {
    
    enum EventType: CaseIterable {
        case reminder
        case dDay
        case deadline
        case dplus

        var text: String {
            switch self {
            case .reminder:
                return "미리알림"
                
            case .dDay:
                return "D - Day"
                
            case .deadline:
                return "마감기한"
                
            case .dplus:
                return "D+"
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(EventType.allCases, id: \.self) { type in
                CalendarEventListCell(type: type)
            }
        }
    }
    
    struct CalendarEventListCell: View {
        let type: EventType
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color.blue)
                
                
                Text(type.text)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("3")
            }
            .contextMenu {
                Button(role: .destructive, action: {
                    // 삭제
                }, label: {
                    Label("삭제", systemImage: "trash")
                })
                Button(action: {
                    //편집
                }) {
                    Label("편집", systemImage: "pencil")
                }
            }
        }
    }
}

struct CalendarListView: View {
    var body: some View {
        List {
            CalendarListCell()
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        // 삭제
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                    
                    Button(action: {
                        // 편집
                    }, label: {
                        Label("편집", systemImage: "pencil")
                    })
                }
            CalendarListCell()
        }
    }
    
    
    struct CalendarListCell: View {
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.blue)
                
                
                Text("개인 일정")
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("6")
            }
            .contextMenu {
                Button(role: .destructive, action: {
                    // 삭제
                }, label: {
                    Label("삭제", systemImage: "trash")
                })
                Button(action: {
                    //편집
                }) {
                    Label("편집", systemImage: "pencil")
                }
            }
        }
    }
}
