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
    
    @State var searchText = ""
    @ObservedObject var sideTabbarViewModel: SideTabBarViewModel
    @StateObject private var viewModel: TravelMapViewModel = TravelMapViewModel()
    
    var body: some View {
        
        NavigationSplitView {
            TextField("장소 검색",text: $searchText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .padding()
            
            Text("가이드 목록")
            Spacer()
            Button(action: {
//                viewModel.apply(.addDestinationFolder)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray5))
                        .frame(height: 44)
                    HStack {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(.black)
                        Text("가이드 추가")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal, 8)
            }
        } detail: {
            Map()
        }
        .sheet(item: $viewModel.sheetType) { sheetType in
            
            switch sheetType {
            case .addFolder:
                AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil))
                
            case .editFolder:
                AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil))
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
    
}
