//
//  UIControl+Extension.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/14.
//

import UIKit.UIControl

typealias ButtonClosure = (UIButton) -> Void

extension UIControl {
    func addButtonAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ButtonClosure) {
        @objc class ClosureSleeve: NSObject {
            let closure: ButtonClosure

            init(_ closure: @escaping ButtonClosure) {
                self.closure = closure
            }

            @objc func invoke(_ sender: UIButton) {
                closure(sender)
            }
        }

        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke(_:)), for: .touchUpInside)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
}
