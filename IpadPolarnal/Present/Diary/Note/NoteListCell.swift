//
//  NoteListCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
#if os(iOS)
import UIKit
typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
typealias PlatformColor = NSColor
#endif

struct NoteListCell: View {
    @StateObject private var viewModel: NoteListCellViewModel
    
    private let rectangleWidth: CGFloat
    private let rectangleHeight: CGFloat
    private let imageWight: CGFloat
    private let imageHeight: CGFloat
    
    init(note: Note,
         isMacOS: Bool = false) {
        
        _viewModel = StateObject(wrappedValue: NoteListCellViewModel(note: note))
        
        rectangleWidth = isMacOS ? 80 : 60
        rectangleHeight = isMacOS ? 80 : 100
        imageWight = isMacOS ? 80 : 100
        imageHeight = isMacOS ? 80 : 100
        
    }
    
    var body: some View {
        HStack(alignment: .top) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(PlatformColor.systemGray))
                .frame(width: rectangleWidth,
                       height: rectangleHeight)
                .overlay {
                    VStack {
                        Text(MonthCase(rawValue: Int(viewModel.monthString)!)?.shortName ?? "@@")
                            .bold()
                            .foregroundStyle(Color.normalText)
                        Text(viewModel.dayString)
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.normalText)
                    }
                }
            VStack(alignment: .leading) {
                Text(viewModel.note.title)
                    .font(.title3)
                    .bold()
                
                Text("\(viewModel.subTitle)")
                    .font(.subheadline)
                    .lineLimit(3)
                
            }
            Spacer()
#if os(macOS)
            if let image = viewModel.thumnailImage {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: imageWight,
                           height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
#elseif os(iOS)
            if let image = viewModel.thumnailImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: imageWight,
                           height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
#endif
            
        }
    }
    
}
