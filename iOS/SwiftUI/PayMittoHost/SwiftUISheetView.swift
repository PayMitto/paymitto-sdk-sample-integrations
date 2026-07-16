//
//  SwiftUISheetView.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

struct SwiftUISheetView: View {
    @State private var viewModel: ViewModel = .init()
    
    var body: some View {
        Button("PayMitto SDK v11.0.0") {
            viewModel.showPayMittoSDK()
        }
        .fullScreenCover(item: $viewModel.payMittoItem) { _ in
            PayMittoSDKContainerView(viewModel: viewModel)
        }
        .navigationTitle("SwiftUI - Sheet")
    }
}

#Preview {
    SwiftUISheetView()
}
