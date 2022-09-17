//
//  NSObject+Extension.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/11.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
