//
//  UIViewController+Rx.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/29.
//
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    var rxViewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
