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
    
    @Environment(\.modelContext) var modelContext
    @ObservedObject var sideTabbarViewModel: SideTabBarViewModel
    @StateObject var viewModel: TravelMapViewModel
    
    var body: some View {
        
        NavigationSplitView {
            
            searchTextView()
            
            if !viewModel.searchText.isEmpty {
                ScrollView {
                    LazyVStack() {
                        ForEach(viewModel.placeList, id: \.self) { result in
                            SearchedResultCell(searchResult: result)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .onTapGesture {
                                    viewModel.apply(.selectLocation(result))
                                }
                        }
                    }
                }
            } else {
            
                Divider()
                
                HStack {
                    Text("가이드 목록")
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        viewModel.apply(.showAddFolder)
                    }, label: {
                        Image(systemName: "plus")
                            .tint(Color.normalText)
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
            Map {
                if let place = viewModel.selectedPlace {
                    Marker(place.title,
                           coordinate: place.coordinate)
                    .tint(.red)
                }
            }
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
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .sheet(item: $viewModel.sheetType, onDismiss: {
            viewModel.apply(.reloadFolderList)
        }) { sheetType in
            
            NavigationStack {
                switch sheetType {
                case .addFolder:
                    AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil,
                                                                                                  travelID: viewModel.travelID))
                    
                case .editFolder:
                    AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil))
                }
            }
            
        }
        .onDisappear {
            viewModel.apply(.cleanManager)
        }
        
        
    }
    
    func searchTextView() -> some View {
        HStack {
            TextField("장소 검색", text: $viewModel.searchText)
                .padding()
                .background(Color.customGray6)
                .cornerRadius(12)
                .padding(.leading, 8)
    
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.apply(.clearSearchText)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
        .padding()
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
                HStack {
                    Text(searchResult.title)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                HStack {
                    Text(searchResult.subtitle)
                        .font(.caption2)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            
        }
    }
    
}

