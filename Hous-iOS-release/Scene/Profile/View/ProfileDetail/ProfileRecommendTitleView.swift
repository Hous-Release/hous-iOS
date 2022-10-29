//
//  ProfileRecommendTitleView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/29.
//

import UIKit

import UIKit

final class ProfileRecommendTitleView : UIView {
  
  private enum Size{
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  let recommendTitleLabel = UILabel().then {
    $0.text = "둥글이가 만들면 좋은 Rules"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.textColor = Colors.yellow.color
  }
    
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
    self.addSubViews([recommendTitleLabel])
    
    recommendTitleLabel.snp.makeConstraints {make in
      make.centerX.centerY.equalToSuperview()
    }
  }
}
