//
//  KeyRulesTableViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/27.
//

import UIKit

class KeyRulesTableViewCell: UITableViewCell {
  
  private let KeyRulesBackgroundView = UIView().then {
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
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  private func configUI() {
    addSubView(KeyRulesBackgroundView)
    
    KeyRulesBackgroundView.addSubViews([ourRulesStackView,ruleEmptyViewLabel]
    )
    
    KeyRulesBackgroundView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
      make.width.equalTo(UIScreen.main.bounds.width * (327/375))
      make.height.equalTo(KeyRulesBackgroundView.snp.width).multipliedBy(0.4770642202)
    }
    
    ourRulesStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }
    
    ruleEmptyViewLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  
  func setKeyRulesCell(ourRules: [String]) {
    if ourRules.count == 0 {
      ourRulesStackView.isHidden = true
      ruleEmptyViewLabel.isHidden = false
      return
    }
    
    ourRulesStackView.subviews.forEach { $0.removeFromSuperview() }
    ourRules.enumerated().forEach { (idx, rule) in
      let label = OurRulesView()
      label.setRulesCell(number: idx+1, ruleText: rule)
      ourRulesStackView.addArrangedSubview(label)
    }
    if ourRules.count < 3 {
      let diff = 3 - ourRules.count
      for i in 0..<diff {
        let label = OurRulesView()
        label.setEmptyRule(number: diff+i)
        ourRulesStackView.addArrangedSubview(label)
      }
    }
    
  }
}
