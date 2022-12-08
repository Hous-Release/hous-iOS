//
//  ProfileDetailTextCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import UIKit

final class ProfileDetailTextCollectionViewCell: UICollectionViewCell {
  
  private enum Size{
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let recommendRuleTitleViewSize = CGSize(width: Size.screenWidth - 48, height: 34)
    static let recommendRuleViewSIze = CGSize(width: Size.screenWidth - 48, height: 86)
  }
  
  private let descriptionView = ProfileDescriptionView()
  
  private let recommendRuleTitleView = ProfileRecommendTitleView()
  
  private let recommendRuleView = ProfileRecommendRuleView()
  
  override init(frame: CGRect){
    super.init(frame: frame)
    configUI()
    render()
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI(){
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubViews([descriptionView, recommendRuleTitleView, recommendRuleView])
    
    descriptionView.snp.makeConstraints {make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
      make.width.equalTo(Size.screenWidth - 48)
    }
    
    recommendRuleTitleView.snp.makeConstraints {make in
      make.centerX.equalToSuperview()
      make.top.equalTo(descriptionView.snp.bottom).offset(18)
      make.width.height.equalTo(Size.recommendRuleTitleViewSize)
    }
    
    recommendRuleView.snp.makeConstraints {make in
      make.centerX.equalToSuperview()
      make.top.equalTo(recommendRuleTitleView.snp.bottom)
      make.width.height.equalTo(Size.recommendRuleViewSIze)
    }
  }
  
  func bind(_ data: ProfileDetailModel) {
    descriptionView.personalityTitleLabel.text = data.title
    var descriptionMessage: String = ""
    for message in data.description {
      descriptionMessage += (message + "\n")
    }
    
    if descriptionMessage.count > 2 {
      let start = descriptionMessage.startIndex
      let end = descriptionMessage.index(descriptionMessage.endIndex, offsetBy: -2)
      let newMessage = descriptionMessage[start...end]
      
      let attrString = NSMutableAttributedString(string: String(newMessage))
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 4
      paragraphStyle.alignment = .center
      attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
      
      descriptionView.personalityDescriptionLabel.attributedText = attrString
    }
    
    recommendRuleTitleView.recommendTitleLabel.text = data.recommendTitle
    
    guard let recommendRuleStackItems =  recommendRuleView.recommendRuleStackView.arrangedSubviews as? [ProfileRecommendRuleStackItemView] else { return }
    
    switch data.personalityType {
    case .red:
      descriptionView.personalityTitleLabel.textColor = Colors.red.color
      recommendRuleTitleView.recommendTitleLabel.textColor = Colors.red.color
      recommendRuleStackItems.forEach {
        $0.indexImageView.image = Images.icCheckRed.image
      }
    case .blue:
      descriptionView.personalityTitleLabel.textColor = Colors.blue.color
      recommendRuleTitleView.recommendTitleLabel.textColor = Colors.blue.color
      recommendRuleStackItems.forEach {
        $0.indexImageView.image = Images.icCheckBlue.image
      }
    case .yellow:
      descriptionView.personalityTitleLabel.textColor = Colors.yellow.color
      recommendRuleTitleView.recommendTitleLabel.textColor = Colors.yellow.color
      recommendRuleStackItems.forEach {
        $0.indexImageView.image = Images.icCheckYellow.image
      }
    case .green:
      descriptionView.personalityTitleLabel.textColor = Colors.green.color
      recommendRuleTitleView.recommendTitleLabel.textColor = Colors.green.color
      recommendRuleStackItems.forEach {
        $0.indexImageView.image = Images.icCheckGreen.image
      }
    case .purple:
      descriptionView.personalityTitleLabel.textColor = Colors.purple.color
      recommendRuleTitleView.recommendTitleLabel.textColor = Colors.purple.color
      recommendRuleStackItems.forEach {
        $0.indexImageView.image = Images.icCheckPurple.image
      }
    case .none:
      recommendRuleTitleView.recommendTitleLabel.textColor = Colors.g1.color
    }
    
    recommendRuleView.recommendRuleList = data.recommendTodo
    recommendRuleView.reloadRuleData()
    
  }
  
}

