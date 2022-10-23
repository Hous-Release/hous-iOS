//
//  TestViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/10/22.
//

import Foundation
import SnapKit
import UIKit

final class TestViewController: UIViewController {

  private let testLabel: UILabel = {
    let label = UILabel()

    label.text = "테스트 라벨입니다."
    label.font = Fonts.Montserrat.bold.font(size: 30)
    return label
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("TestViewController is not implemented")
  }

  private func setupViews() {
    view.addSubview(testLabel)

    testLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
