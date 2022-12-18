//
//  ProfileRecommendRuleView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/29.
//

import UIKit

final class ProfileRecommendRuleStackItemView : UIView {
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let imageSize = CGSize(width: 12, height: 8)
  }
  
  let indexImageView = UIImageView().then {
    $0.image = Images.icCheckYellow.image
  }
  
  private let recommendRuleLabel = UILabel().then {
    $0.text = "default"
    $0.textColor = Colors.g7.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .center
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: recommendRuleLabel.intrinsicContentSize.height)
  }
  private func render(){
    self.addSubViews([indexImageView, recommendRuleLabel])
    
    indexImageView.snp.makeConstraints {make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
      make.width.height.equalTo(Size.imageSize)
    }
    
    recommendRuleLabel.snp.makeConstraints {make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(indexImageView.snp.trailing).offset(10)
      make.trailing.equalToSuperview()
    }
  }
  
  func setLabelText(_ text: String) {
    recommendRuleLabel.text = text
  }
  
}

final class ProfileRecommendRuleView : UIView {
  
  private enum Size{
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  let recommendRuleStackView = UIStackView().then {
    $0.distribution = .equalSpacing
    $0.alignment = .center
    $0.spacing = 7
    $0.axis = .vertical
  }
  
  var recommendRuleStackItems: [ProfileRecommendRuleStackItemView] = []
  
  var recommendRuleList = ["", ""]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI(){
    self.backgroundColor = .white
    self.layer.cornerRadius = 15
    self.layer.masksToBounds = true
  }
  
  private func render(){
    for i in 0...1 {
      let recommendRuleStackItem = ProfileRecommendRuleStackItemView()
      recommendRuleStackItem.setLabelText(recommendRuleList[i])
      recommendRuleStackItems.append(recommendRuleStackItem)
    }
    
    recommendRuleStackView.addArrangedSubviews(recommendRuleStackItems[0], recommendRuleStackItems[1])
    self.addSubViews([recommendRuleStackView])
    
    recommendRuleStackView.snp.makeConstraints {make in
      make.top.equalToSuperview().offset(3)
      make.centerX.equalToSuperview()
//      make.bottom.equalToSuperview().offset(-32)
    }
  }
  
  func reloadRuleData() {
    for i in 0...1 {
      guard let stackItem = recommendRuleStackView.arrangedSubviews[i] as? ProfileRecommendRuleStackItemView else { return }
      stackItem.setLabelText(recommendRuleList[i])
    }
  }
}
