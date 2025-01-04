//
//  TravelMapView.swift
//  Polarnal
//
//  Created by 최승범 on 12/24/24.
//

import SwiftUI
import SwiftData

struct TravelMapView: View {
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
        
        List {
            TravelMapListCell()
        }
    }
}

struct TravelMapListCell: View {
    var body: some View {
        Text("도쿄 타워")
    }
}
