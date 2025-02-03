//
//  TravelDestinationListView.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import SwiftUI
import SwiftData

struct TravelDestinationListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var travelDestinationList: [TravelDestinationFolderDB]
    @StateObject private var viewModel: TravelDestinationViewModel = TravelDestinationViewModel()
    
    var body: some View {
        List {
            ForEach(travelDestinationList, id: \.id) { folder in
                TravelDestinationFolderCell(folder: folder,
                                            viewModel: viewModel)
                .padding(.top, 4)
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        viewModel.apply(.deleteDestinationFolder(folder))
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                    
                    Button(action: {
                        viewModel.apply(.editEDestinationFolder(folder))
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
    
    struct TravelDestinationFolderCell: View {
        
        let folder: TravelDestinationFolderDB
        let viewModel: TravelDestinationViewModel
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32, height: 32)
                //                    .foregroundStyle(category.color.convertToColor())
                    .foregroundStyle(.red)
                
                Text(folder.title)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("\(folder.destinationList.count)")
            }
            .contextMenu {
                Button(role: .destructive, action: {
                    viewModel.apply(.deleteDestinationFolder(folder))
                }, label: {
                    Label("삭제", systemImage: "trash")
                })
                Button(action: {
                    viewModel.apply(.editEDestinationFolder(folder))
                }) {
                    Label("편집", systemImage: "pencil")
                }
            }
        }
    }
}

