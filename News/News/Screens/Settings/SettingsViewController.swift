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

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.outputDelegate = self
        setupUI()
    }

    enum SettingType {
        case theme
        case notification
        case defaultItem
    }

    struct SettingItem {
        let title: String
        let icon: String
        let type: SettingType
    }

    private let settingsSections: [[SettingItem]] = [
        [SettingItem(title: "App Theme", icon: "circle.righthalf.filled", type: .theme)],
        [SettingItem(title: "Notification", icon: "bell.fill", type: .notification)],
        [SettingItem(title: "Rate Us", icon: "star.fill", type: .defaultItem)],
        [SettingItem(title: "Privacy Policy", icon: "text.document.fill", type: .defaultItem),
         SettingItem(title: "Terms of Use", icon: "checkmark.shield.fill", type: .defaultItem)]
    ]
}

// MARK: - Private Methods

private extension SettingsViewController {
    func setupUI () {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    self.updateNotificationSwitchState(isOn: true)
                }
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.updateNotificationSwitchState(isOn: false)
                }
            }
        }
    }

    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    func updateNotificationSwitchState(isOn: Bool) {
        if let notificationCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) {
            if let switchControl = notificationCell.accessoryView as? UISwitch {
                switchControl.isOn = isOn
            }
        }
    }

    func openAppStore() {
        let googleMapsID = "585027354"
        let urlString = "https://apps.apple.com/us/app/google-maps/id/\(googleMapsID)"

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func openLinkInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: Table View

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        settingsSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsSections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = settingsSections[indexPath.section][indexPath.row]

        cell.textLabel?.text = item.title
        cell.imageView?.image = UIImage(systemName: item.icon)
        cell.imageView?.tintColor = .label
        cell.accessoryView = nil
        cell.selectionStyle = .none

        switch item.type {
        case .theme:
            let themeControl = UISegmentedControl(items: ["Light", "Dark"])
            let currentStyle = traitCollection.userInterfaceStyle
            themeControl.selectedSegmentIndex = (currentStyle == .dark) ? 1 : 0
            themeControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
            cell.accessoryView = themeControl

        case .notification:
            let switchControl = UISwitch()
            checkNotificationPermission { isAuthorized in
                switchControl.isOn = isAuthorized
            }
            switchControl.addTarget(self, action: #selector(notificationToggled(_:)), for: .valueChanged)
            cell.accessoryView = switchControl

        case .defaultItem:
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settingsSections[indexPath.section][indexPath.row]

        switch item.type {
        case .defaultItem:
            if item.title == "Rate Us" {
                openAppStore()
            } else if item.title == "Privacy Policy" {
                openLinkInSafari(urlString: "https://www.google.com")
            } else if item.title == "Terms of Use" {
                openLinkInSafari(urlString: "https://www.google.com")
            }

        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc private func themeChanged(_ sender: UISegmentedControl) {
        let selectedTheme = sender.selectedSegmentIndex == 0 ? UIUserInterfaceStyle.light : UIUserInterfaceStyle.dark

        overrideUserInterfaceStyle = selectedTheme

        UIView.animate(withDuration: 0.3) {
            self.view.window?.overrideUserInterfaceStyle = selectedTheme
        }
    }

    @objc private func notificationToggled(_ sender: UISwitch) {
        if sender.isOn {
            requestNotificationPermission()
        } else {
            print("Notifications turned OFF")
        }
    }
}

// MARK: - SettingsOutputProtocol

extension SettingsViewController: SettingsOutputProtocol {}
