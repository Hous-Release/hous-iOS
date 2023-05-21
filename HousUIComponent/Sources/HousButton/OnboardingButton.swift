//
//  OnboardingButton.swift
//  
//
//  Created by 김지현 on 2023/05/21.
//

import UIKit
import AssetKit

internal final class OnboardingButton: UIButton {

    private typealias SpoqaHanSansNeo = Fonts.SpoqaHanSansNeo

    override var isEnabled: Bool {
        didSet {

        }
    }

    

    internal override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {

        self.titleLabel?.font = SpoqaHanSansNeo.bold.font(size: 18)
        self.setTitleColor(.white, for: [.normal, .disabled])
    }
}
