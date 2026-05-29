//
//  UIKitPush.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

struct UIKitPush: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: UIKitPushViewController())
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // no-op
    }
}
