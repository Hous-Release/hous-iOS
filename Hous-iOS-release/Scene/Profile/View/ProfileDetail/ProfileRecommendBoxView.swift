//
//  ProfileRecommendBoxView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/29.
//

import UIKit

enum CellType: String {
  case empty = ""
  case bad = "맞춰가요"
  case good = "찰떡궁합"
}

final class ProfileRecommendBoxView: UIView {
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let imageSize = CGSize(width: 120, height: 120)
  }
  
  let titleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.g5.color
  }
  
  let personalityLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.black.color
  }
  
  let personalityImageView = UIImageView().then {
    $0.image = nil
  }
  
  private let neumorphismBox = NeumorphismBox(shadowColor: Colors.black.color.cgColor, shadowOpacity: 0.05, shadowRadius: 3)
  
  convenience init(personalityColor: PersonalityColor, cellType : CellType) {
    self.init(frame: .zero)
    configUI(personalityColor: personalityColor, cellType: cellType)
    render()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI(personalityColor: PersonalityColor, cellType: CellType){
    self.layer.cornerRadius = 20
    self.layer.masksToBounds = true
    
    titleLabel.text = cellType.rawValue
    
    personalityLabel.text = "룰 새터 육각이"
    
    // 서버 통신 시 URL로 설정
    personalityImageView.image = Images.tempIlluResult01.image
  }
  
  private func render(){
    self.addSubViews([neumorphismBox, titleLabel, personalityLabel, personalityImageView])
    
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(24)
    }
    
    personalityLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(2)
    }
    
    personalityImageView.snp.makeConstraints { make in
      make.width.height.equalTo(Size.imageSize)
      make.centerX.equalToSuperview()
      make.top.equalTo(personalityLabel.snp.bottom)
    }
    
    neumorphismBox.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(Size.screenWidth / 2 - 40)
      make.height.equalToSuperview().inset(8)
    }
  
  }
}
