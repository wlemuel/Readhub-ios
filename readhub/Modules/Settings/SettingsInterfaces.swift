//
//  SettingsInterfaces.swift
//  readhub
//
//  Created by Steve Lemuel on 11/8/19.
//  Copyright (c) 2019 Steve Lemuel. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import RxSwift
import RxCocoa

enum Settings {

    struct ViewOutput {
    }

    struct ViewInput {
    }

}

protocol SettingsWireframeInterface: WireframeInterface {
}

protocol SettingsViewInterface: ViewInterface {
}

protocol SettingsPresenterInterface: PresenterInterface {
    func configure(with output: Settings.ViewOutput) -> Settings.ViewInput
}
