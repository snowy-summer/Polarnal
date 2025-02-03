//
//  AddFolderView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/3/25.
//

import SwiftUI

struct AddFolderView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddFolderViewModel
    
    init(folder: Folder?) {
        _viewModel = StateObject(wrappedValue: AddFolderViewModel(folder: folder))
    }
    
    var body: some View {
        
            VStack {
                Text("New Folder")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                TextField("Folder Name", text: $viewModel.folderTitle)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                
                ColorPalettePartView(selctedColor: $viewModel.folderColor)
                    .background(.ipadTabbar)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Divider()
                
                HStack {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Button("Add Folder") {
                        viewModel.apply(.addFolder)
                        dismiss()
                    }
                    .disabled(viewModel.folderTitle.isEmpty)
                    
                }
                
               
//                
//                IconSelectPartView(viewModel: viewModel)
//                    .background(Color(UIColor.systemGray5))
//                    .clipShape(RoundedRectangle(cornerRadius: 24))
//                    .padding(40)
                
            }
            .padding()
        
        .navigationTitle("폴더 생성ddd")
//        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
    
}
