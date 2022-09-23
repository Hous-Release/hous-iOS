//
//  MainHomeRulesCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/11.
//

import UIKit

class MainHomeRulesCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "MainHomeRulesCollectionViewCell"
  
  private let ourRulesTitleLabel = UILabel().then {
    $0.text = "Our Rules"
    $0.font = Fonts.Montserrat.semiBold.font(size: 18)
    $0.textAlignment = .left
    $0.textColor = Colors.black.color
  }
  
  private let ourRulesArrowButton = UIButton().then {
    $0.setImage(Images.icMoreOurRules.image, for: .normal)
  }
  
  private let ourRulesBackgroundView = UIView().then {
    $0.backgroundColor = Colors.blueL2.color
    $0.layer.cornerRadius = 8
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI() {
    
    self.contentView.addSubViews([
      ourRulesTitleLabel,
      ourRulesArrowButton,
      ourRulesBackgroundView
    ])
    ourRulesTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.leading.equalToSuperview().offset(32)
    }
    
    ourRulesArrowButton.snp.makeConstraints { make in
      make.centerY.equalTo(ourRulesTitleLabel)
      make.leading.equalTo(ourRulesTitleLabel.snp.trailing).offset(2)
    }
    
    ourRulesBackgroundView.snp.makeConstraints { make in
      make.top.equalTo(ourRulesTitleLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(24)
      make.width.equalTo(UIScreen.main.bounds.width * (327/375))
      make.height.equalTo(ourRulesBackgroundView.snp.width).multipliedBy(0.4770642202)
    }
  }
  
  
}
