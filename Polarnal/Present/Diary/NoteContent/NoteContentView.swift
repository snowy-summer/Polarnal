//
//  NoteContentView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct NoteContentView: View {
    @State private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        
        
        List {
            TextField("제목", text: $title)
                .font(.title)
                .frame(height: 80)
                .padding()
            NoteContentToolView()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
                .frame(height: 120)
        }
        .listStyle(.plain)
    }
    
}

struct NoteContentToolView: View {
    @State private var selectedCircleIndex: Int? = nil
    @State private var select = false
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: select ? 12 : 40)
                    .fill(.gray)
                    .frame(width: 80, height: 80)
                    .transition(.opacity)
                    .animation(.linear(duration: 0.3),
                               value: select)
                    .onTapGesture {
                        select.toggle()
                    }
                
            }
        }
    }
}

#Preview {
    NoteContentView(title: "")
//    NoteContentToolView()
}
