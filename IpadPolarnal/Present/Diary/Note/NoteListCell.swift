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
    
    init(note: Note) {
        _viewModel = StateObject(wrappedValue: NoteListCellViewModel(note: note))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(PlatformColor.systemGray))
                .frame(width: 60,
                       height: 100)
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
                if !viewModel.note.contents.isEmpty,
                   let text = viewModel.note.contents.first?.textValue {
                    Text("\(text)")
                }
            }
            Spacer()
#if os(macOS)
            if let image = viewModel.thumnailImage {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: 100,
                           height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
#elseif os(iOS)
            if let image = viewModel.thumnailImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100,
                           height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
#endif
            
        }
    }
    
}
