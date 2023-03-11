//
//  MainHomeRulesCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/11.
//

import UIKit
import RxSwift

class MainHomeRulesCollectionViewCell: UICollectionViewCell {

  private let ourRulesTitleLabel = UILabel().then {
    $0.text = "Our Rules"
    $0.font = Fonts.Montserrat.semiBold.font(size: 18)
    $0.textAlignment = .left
    $0.textColor = Colors.black.color
  }

  let ourRulesArrowButton = UIButton().then {
    $0.setImage(Images.icMoreOurRules.image, for: .normal)
  }

  let ourRulesBackgroundView = UIView().then {
    $0.backgroundColor = Colors.blueL2.color
    $0.layer.cornerRadius = 8
  }

  private let ruleEmptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 우리 집 Rules가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
  }

  private let ourRulesStackView = UIStackView(arrangedSubviews: []).then {
    $0.axis = .vertical
    $0.backgroundColor = Colors.blueL1.color
    $0.spacing = 1
    $0.distribution = .fillEqually
  }

  var disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  private func configUI() {

    self.contentView.addSubViews([
      ourRulesTitleLabel,
      ourRulesArrowButton,
      ourRulesBackgroundView
    ])

    ourRulesBackgroundView.addSubViews([ourRulesStackView, ruleEmptyViewLabel])

    ourRulesTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(32)
    }

    ourRulesArrowButton.snp.makeConstraints { make in
      make.centerY.equalTo(ourRulesTitleLabel)
      make.leading.equalTo(ourRulesTitleLabel.snp.trailing).offset(2)
    }

    ourRulesBackgroundView.snp.makeConstraints { make in
      make.top.equalTo(ourRulesTitleLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(156)
    }

    ourRulesStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.top.bottom.equalToSuperview().inset(10)
    }

    ruleEmptyViewLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  func setHomeRulesCell(ourRules: [String]) {
    if ourRules.count == 0 {
      ourRulesStackView.isHidden = true
      ruleEmptyViewLabel.isHidden = false
      return
    } else {
      ourRulesStackView.isHidden = false
      ruleEmptyViewLabel.isHidden = true
    }

    ourRulesStackView.subviews.forEach { $0.removeFromSuperview() }
    ourRules.enumerated().forEach { (idx, rule) in
      let label = OurRulesView()
      label.setRulesCell(number: idx+1, ruleText: rule)
      ourRulesStackView.addArrangedSubview(label)
    }
    var number = ourRules.count

    if number < 3 {
      let diff = 3 - ourRules.count

      for _ in 0..<diff {
        let label = OurRulesView()
        label.setEmptyRule(number: number+1)
        ourRulesStackView.addArrangedSubview(label)
        number += 1
      }
    }

  }
}
