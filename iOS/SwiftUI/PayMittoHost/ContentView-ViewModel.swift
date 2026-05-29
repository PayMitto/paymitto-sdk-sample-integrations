//
//  ContentView-ViewModel.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 9/4/25.
//

import SwiftUI

extension ContentView {
    enum RouterDestination {
        case swiftUISheet
        case uiKitPresent
    }
    
    @Observable
    class ViewModel {
        var path: NavigationPath = .init()
        var showingUIKitPush: Bool = false
    }
}
