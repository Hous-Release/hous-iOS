//
//  Reactive+Extension.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/14.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
  public var viewWillAppear: Observable<[Any]> {
    return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
  }
}

