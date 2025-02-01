//
//  SettingsViewModel.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

protocol SettingsInputProtocol: AnyObject {}

final class SettingsViewModel {

    weak var inputDelegate: SettingsInputProtocol?
    weak var outputDelegate: SettingsOutputProtocol?

    init() {
        inputDelegate = self
    }
}

// MARK: - SettingsInputProtocol

extension SettingsViewModel: SettingsInputProtocol {}
