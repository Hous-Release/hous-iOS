//
//  OurRulesView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/24.
//

import UIKit

final class OurRulesView: UIView {

  private let dotImageView = UIImageView().then {
    $0.image = Images.icStildot.image
    $0.contentMode = .scaleAspectFit
  }

  private let ruleTextLabel = UILabel().then {
    $0.text = "다른 Rule도 추가해보세요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g4.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI() {
    backgroundColor = Colors.blueL2.color
    addSubViews([dotImageView, ruleTextLabel])

    dotImageView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    ruleTextLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(24)
      make.centerY.equalTo(dotImageView)
      make.bottom.equalToSuperview()
    }
  }

  func setRulesCell(number: Int, ruleText: String) {
    ruleTextLabel.textColor = Colors.black.color
    ruleTextLabel.text = ruleText
  }

  func setEmptyRule(number: Int) {
    ruleTextLabel.textColor = Colors.g4.color
  }

}
