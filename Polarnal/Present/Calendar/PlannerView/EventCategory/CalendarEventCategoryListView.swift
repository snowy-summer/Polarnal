//
//  CalendarEventCategoryListView.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI
import SwiftData

struct CalendarEventCategoryListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var eventCategoryList: [EventCategoryDB]
    @StateObject private var viewModel: CalendarEventCategoryViewModel = CalendarEventCategoryViewModel()
    
    var body: some View {
        List {
            ForEach(eventCategoryList, id: \.id) { category in
                CalendarEventCategoryCell(category: category,
                                          viewModel: viewModel)
                    .padding(.top, 4)
                    .swipeActions(edge: .trailing,
                                  allowsFullSwipe: false) {
                        Button(role: .destructive, action: {
                            viewModel.apply(.deleteEventCategory(category))
                        }, label: {
                            Label("삭제", systemImage: "trash")
                        })
                        
                        Button(action: {
                            viewModel.apply(.editEventCategory(category))
                        }, label: {
                            Label("편집", systemImage: "pencil")
                        })
                    }
                                  
            }
        }
        .sheet(item: $viewModel.isShowEditEventCategoryView, content: { category in
            NavigationStack {
                AddEventCategoryView(viewModel: AddEventCategoryViewModel(eventCategory: category))
            }
        })
        .onAppear {
            viewModel.apply(.insertDB(modelContext))
        }
    }
    
    
    struct CalendarEventCategoryCell: View {
        
        let category: EventCategoryDB
        let viewModel: CalendarEventCategoryViewModel
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(category.color.convertToColor())
                
                
                Text(category.title)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("\(category.planList.count)")
            }
            .contextMenu {
                Button(role: .destructive, action: {
                    viewModel.apply(.deleteEventCategory(category))
                }, label: {
                    Label("삭제", systemImage: "trash")
                })
                Button(action: {
                    viewModel.apply(.editEventCategory(category))
                }) {
                    Label("편집", systemImage: "pencil")
                }
            }
        }
    }
}
