//
//  ScreenUtils.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/14.
//

import UIKit

final class ScreenUtils {
    static func getWidth(_ value: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let standardWidth: CGFloat = 375.0
        return width / standardWidth * value
    }

    static func getHeight(_ value: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let standardheight: CGFloat = 812.0
        return height / standardheight * value
    }
}
