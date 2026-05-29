//
//  ViewController.swift
//  ReadyRemitHost
//
//  Created by Franco Cadillo on 3/6/26.
//

import SwiftUI

class ViewController: UIViewController {
    private let viewModel: ViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupObservation()
    }
    
    private func setupButton() {
        let action = UIAction { _ in
            self.viewModel.showReadyRemitSDK()
        }
        
        let button = UIButton(primaryAction: action)
        button.setTitle("ReadyRemit SDK v10.0.0", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupObservation() {
        withObservationTracking {
            _ = viewModel.readyRemitItem
        } onChange: { [weak self] in
            guard let self else { return }
            Task {
                await MainActor.run {
                    if let readyRemitItem = self.viewModel.readyRemitItem {
                        let hostingController = UIHostingController(rootView: AnyView(readyRemitItem.view))
                        hostingController.modalPresentationStyle = .fullScreen
                        self.present(hostingController, animated: true)
                    }
                }
            }
        }
    }
}
