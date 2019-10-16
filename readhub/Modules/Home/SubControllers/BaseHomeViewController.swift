//
//  BaseHomeViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseHomeViewController: BaseViewController {
    var presenter: HomePresenterInterface!
    
    var disposeBag = DisposeBag()

    init(presenter: HomePresenterInterface) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

