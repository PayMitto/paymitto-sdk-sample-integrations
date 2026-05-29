//
//  UIKitPresentViewController.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/24/25.
//

import SwiftUI

class UIKitPresentViewController: UIViewController {
    private let viewModel: ViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLaunchSDKButton()
        setupObservation()
    }

    private func setupLaunchSDKButton() {
        let action = UIAction { _ in
            self.viewModel.showPayMittoSDK()
        }
        
        let button = UIButton(primaryAction: action)
        button.setTitle("PayMitto SDK v11.0.0", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupObservation() {
        withObservationTracking {
            _ = viewModel.payMittoItem
        } onChange: { [weak self] in
            guard let self else { return }
            Task {
                await MainActor.run {
                    if let payMittoItem = self.viewModel.payMittoItem {
                        let hostingController = UIHostingController(rootView: AnyView(payMittoItem.view))
                        hostingController.modalPresentationStyle = .fullScreen
                        self.present(hostingController, animated: true)
                    }
                    self.setupObservation()
                }
            }
        }
    }
}
