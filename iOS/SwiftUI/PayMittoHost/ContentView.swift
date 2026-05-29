//
//  ContentView.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 9/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: ViewModel = .init()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                Section {
                    NavigationLink(value: RouterDestination.swiftUISheet) {
                        Text("SwiftUI - Sheet")
                    }
                    NavigationLink(value: RouterDestination.uiKitPresent) {
                        Text("UIKit - Present")
                    }
                }
                
                Section {
                    Button("UIKit - Push") {
                        viewModel.showingUIKitPush = true
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.primary)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .fullScreenCover(isPresented: $viewModel.showingUIKitPush) {
                UIKitPush()
                    .ignoresSafeArea()
                    .navigationTitle("UIKit - Push")
            }
            .navigationDestination(for: RouterDestination.self) {
                switch $0 {
                case .swiftUISheet:
                    SwiftUISheetView()
                case .uiKitPresent:
                    UIKitPresent()
                        .navigationTitle("UIKit - Present")
                }
            }
            .navigationTitle("PayMitto Integrations")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
