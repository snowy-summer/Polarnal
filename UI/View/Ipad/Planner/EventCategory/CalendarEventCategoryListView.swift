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
        .scrollContentBackground(.hidden)
        .background(Color.listBackground)
        .sheet(item: $viewModel.isShowEditEventCategoryView, content: { category in
            NavigationStack {
                AddEventCategoryView(viewModel: AddEventCategoryViewModel(eventCategory: category))
            }
        })
        .onAppear {
            let repository = EventCategoryRepository(modelContext: modelContext)
            let useCase = EventCategoryUseCase(eventCategoryRepository: repository)
            viewModel.apply(.ingectDependencies(useCase: useCase))
        }
    }
    
    struct CalendarEventCategoryCell: View {
        
        let category: EventCategoryDB
        let viewModel: CalendarEventCategoryViewModel
        
#if os(macOS)
        private let isMacOS: Bool = true
#else
        private let isMacOS: Bool = false
#endif
        
        private var cornerRadius: CGFloat {
            isMacOS ? 4 : 8
            
        }
        
        private var rectangleSize: CGFloat {
            isMacOS ? 20 : 32
        }
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: rectangleSize,
                           height: rectangleSize)
                    .foregroundStyle(Color(hex: category.colorCode))
                
                Text(category.title)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("\(category.planList?.count ?? 0000)")
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
