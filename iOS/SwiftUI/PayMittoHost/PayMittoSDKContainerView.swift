//
//  PayMittoSDKContainerView.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 7/16/26.
//

import SwiftUI

struct PayMittoSDKContainerView: View {
    @Bindable var viewModel: ViewModel

    var body: some View {
        Group {
            if let item = viewModel.payMittoItem {
                AnyView(item.view)
            }
        }
        .alert("Verification Required", isPresented: $viewModel.isPresentingChallenge) {
            TextField("Challenge code", text: $viewModel.challengeCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
            Button("Submit") { viewModel.submitChallenge() }
            Button("Cancel", role: .cancel) { viewModel.cancelChallenge() }
        } message: {
            Text("Enter the challenge code to continue creating your transfer.")
        }
    }
}
