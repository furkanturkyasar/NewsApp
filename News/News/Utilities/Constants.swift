//
//  Constants.swift
//  News
//
//  Created by Furkan Türkyaşar on 8.02.2025.
//

import Foundation

enum Constants: String {
    case rateUs = "rate_us"
    case privacyPolicy = "privacy_policy"
    case termsOfService = "terms_of_user"

    init?(localizedTitle: String) {
        if localizedTitle == NSLocalizedString(Self.rateUs.rawValue, comment: "") {
            self = .rateUs
        } else if localizedTitle == NSLocalizedString(Self.privacyPolicy.rawValue, comment: "") {
            self = .privacyPolicy
        } else if localizedTitle == NSLocalizedString(Self.termsOfService.rawValue, comment: "") {
            self = .termsOfService
        } else {
            return nil
        }
    }
}
