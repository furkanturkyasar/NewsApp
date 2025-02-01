//
//  SettingsViewController.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import UIKit

protocol SettingsOutputProtocol: AnyObject {}

final class SettingsViewController: UIViewController {

    private let viewModel: SettingsViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.outputDelegate = self
        setupUI()
    }
}

// MARK: - Private Methods

private extension SettingsViewController {
    func setupUI () {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - SettingsOutputProtocol

extension SettingsViewController: SettingsOutputProtocol {}
