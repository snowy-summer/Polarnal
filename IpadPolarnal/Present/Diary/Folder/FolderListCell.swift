//
//  FolderListCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct FolderListCell: View {
    
    private let folder: Folder
    
    init(folder: Folder) {
        self.folder = folder
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 40, height: 40)
//                    .foregroundStyle(Color(red: folder.color.red,
//                                           green: folder.color.green,
//                                           blue: folder.color.blue,
//                                           opacity: folder.color.alpha))
                    .foregroundStyle(Color(hex: folder.colorCode))
                
                Image(systemName: DesignOfFolderIcon(rawValue: folder.icon).iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
            }
            
            Text(folder.title)
                .bold()
                .padding(.leading, 8)
            
            Spacer()
            
            Text("\(folder.noteList.count)")
        }
    }
    
}
