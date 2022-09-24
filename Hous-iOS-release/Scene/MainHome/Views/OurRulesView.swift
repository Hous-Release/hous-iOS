//
//  OurRulesView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/24.
//

import UIKit

class OurRulesView: UIView {
  
  private let numberLabel = UILabel().then {
    $0.font = Fonts.Montserrat.semiBold.font(size: 16)
    $0.textColor = Colors.blue.color
  }
  
  private let ruleTextLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.black.color
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
    addSubViews([numberLabel, ruleTextLabel])
    
    numberLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    ruleTextLabel.snp.makeConstraints { make in
      make.leading.equalTo(numberLabel.snp.trailing).offset(14)
      make.centerY.equalTo(numberLabel)
      make.bottom.equalToSuperview()
    }
  }
  
  func setRulesCell(number: Int, ruleText: String) {
    numberLabel.text = "\(number)."
    ruleTextLabel.text = ruleText
  }
  
}
