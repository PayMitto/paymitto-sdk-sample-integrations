//
//  UIKitPresent.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

struct UIKitPresent: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIKitPresentViewController {
        UIKitPresentViewController()
    }

    func updateUIViewController(_ uiViewController: UIKitPresentViewController, context: Context) {
        // no-op
    }
}
