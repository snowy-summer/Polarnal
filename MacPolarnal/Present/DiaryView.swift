//
//  DiaryView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/3/25.
//

import SwiftUI
import Combine

struct DiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var stateViewModel: DiaryStateViewModel
    @StateObject var uiViewModel: DiaryUIViewModel
    @StateObject var folderViewModel: FolderListViewModel
    @StateObject var noteViewModel: NoteListViewModel
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    
    private let newFolderTitle: LocalizedStringKey = "New Folder"
    
    var body: some View {
            HStack {
                SideTabBarView(viewModel: sideTabBarViewModel)
                    .frame(maxHeight: .infinity)
                    .frame(width: 72)
                
//                ZStack {
//                    Rectangle()
//                        .fill(.white)
//                        .frame(maxHeight: .infinity)
//                        .frame(width: 72)
//                        .overlay(Color(nsColor: NSColor.controlBackgroundColor).opacity(0.5))
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(.calendarSelect)
//                        .frame(width: 54, height: 54)
//                }
                NavigationView {
                    VStack {
                        FolderListView(stateViewModel: stateViewModel,
                                       uiViewModel: uiViewModel,
                                       folderListViewModel: folderViewModel)
                        
                        Button(action: {
                            uiViewModel.apply(.showAddFolderView)
                        }) {
                            Label(newFolderTitle, systemImage: "plus.circle")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom)
                    }
                    
                    NoteListView(stateViewModel: stateViewModel,
                                 noteListViewModel: noteViewModel)
                    .navigationTitle(stateViewModel.selectedFolder?.title ?? "")
                    
                    Group {
                        if let _ = stateViewModel.selectedNote {
                            NoteContentView(noteContentViewModel: noteViewModel)
                        } else {
                            Text("노트를 선택 해주세요")
                        }
                    }
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                stateViewModel.apply(.addNote)
                            }) {
                                Image(systemName: "plus")
                                    .tint(Color.normalText)
                            }
                        }
                    }
                }
            }
            .sheet(item: $uiViewModel.sheetType, onDismiss: {
                folderViewModel.apply(.fetchFolderList)
            }) { type in
                AddFolderView(folder: nil)
//                NavigationStack {
//                    switch type {
//                    case .addFolder:
//                        AddFolderView(folder: nil)
//                        
//                    case .editFolder(let folder):
//                        AddFolderView(folder: folder)
//                        
//                    default:
//                        EmptyView()
//                    }
//                }
            }
            .onAppear {
                folderViewModel.apply(.insertModelContext(modelContext))
                noteViewModel.apply(.insertModelContext(modelContext))
            }
            
    }
    
}


