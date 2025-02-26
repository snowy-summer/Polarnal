//
//  AddFolderView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

#if os(iOS)
import SwiftUI

struct AddFolderView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddFolderViewModel
    
    init(folder: Folder?) {
        _viewModel = StateObject(wrappedValue: AddFolderViewModel(folder: folder))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TagPartView(viewModel: viewModel)
                    .background(Color.customGray5)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(40)
                
                ColorPalettePartView(selctedColor: $viewModel.folderColor)
                    .background(Color.customGray5)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal,40)
                
                IconSelectPartView(viewModel: viewModel)
                    .background(Color.customGray5)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(40)
                
            }
        }
        .navigationTitle("폴더 생성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("취소") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    viewModel.apply(.addFolder)
                    dismiss()
                }
            }
        }
        .onAppear() {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
    
}
#endif
