//
//  TravelMapView.swift
//  Polarnal
//
//  Created by 최승범 on 12/24/24.
//

import SwiftUI
import MapKit
import SwiftData

struct TravelMapView: View {
    
    @ObservedObject var sideTabbarViewModel: SideTabBarViewModel
    @StateObject private var viewModel: TravelMapViewModel = TravelMapViewModel()
    
    var body: some View {
        
        NavigationSplitView {
            TextField("장소 검색",text: $viewModel.searchText)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding()
            
            if !viewModel.searchText.isEmpty {
                ScrollView {
                    LazyVStack() {
                        ForEach(viewModel.placeList, id: \.self) { result in
                            SearchedResultCell(searchResult: result)
                                .padding(.vertical)
                        }
                    }
                }
            } else {
                
                HStack {
                    Text("가이드 목록")
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        viewModel.apply(.addFolder)
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .padding(.horizontal)
                }
                List {
                    ForEach(viewModel.destinationFolderList, id: \.id) { folder in
                        DestinationFolderCell(folder: folder)
                    }
                }
              
            }
            Spacer()
        } detail: {
            Map()
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            sideTabbarViewModel.apply(.dismissShowMapView)
                        }) {
                            Text("Back")
                        }
                    }
                })
        }
        .sheet(item: $viewModel.sheetType) { sheetType in
            
            NavigationStack {
                switch sheetType {
                case .addFolder:
                    AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil))
                    
                case .editFolder:
                    AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil))
                }
            }
            
        }
        .onDisappear {
            viewModel.apply(.cleanManager)
        }
       

    }
    
    struct DestinationFolderCell: View {
        
        let folder: TravelDestinationFolderDB
//        let viewModel: CalendarEventCategoryViewModel
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(folder.color.convertToColor())
                
                Text(folder.title)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("\(folder.destinationList.count)")
            }
//            .contextMenu {
//                Button(role: .destructive, action: {
//                    viewModel.apply(.deleteEventCategory(category))
//                }, label: {
//                    Label("삭제", systemImage: "trash")
//                })
//                Button(action: {
//                    viewModel.apply(.editEventCategory(category))
//                }) {
//                    Label("편집", systemImage: "pencil")
//                }
//            }
        }
    }
    
    struct SearchedResultCell: View {
        
        let searchResult: MKLocalSearchCompletion
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(searchResult.title)
                Text(searchResult.subtitle)
                    .font(.caption2)
            }
        }
    }
    
}

