//
//  FolderListCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct FolderListCell: View {
    private let folder: Folder
    private let iconSize: CGFloat
    private let cornerRadius: CGFloat
    private let rectangleSize: CGFloat

    init(folder: Folder,
         isMac: Bool = false) {
        self.folder = folder
        self.iconSize = isMac ? 12 : 20
        self.cornerRadius = isMac ? 4 : 8
        self.rectangleSize = isMac ? 20 : 40
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: rectangleSize,
                           height: rectangleSize)
                    .foregroundStyle(Color(hex: folder.colorCode))
                
                Image(systemName: DesignOfFolderIcon(rawValue: folder.icon).iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: iconSize,
                           height: iconSize)
            }
            
            Text(folder.title)
                .bold()
            
            Spacer()
            
            Text("\(folder.noteList.count)")
        }
    }
}
