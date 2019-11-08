//
//  SettingsWireframe.swift
//  readhub
//
//  Created by Steve Lemuel on 11/8/19.
//  Copyright (c) 2019 Steve Lemuel. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import RxCocoa
import RxSwift
import UIKit

final class SettingsWireframe: BaseWireframe {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = SettingsViewController()
        super.init(viewController: moduleViewController)

        let presenter = SettingsPresenter(view: moduleViewController, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension SettingsWireframe: SettingsWireframeInterface {
}
