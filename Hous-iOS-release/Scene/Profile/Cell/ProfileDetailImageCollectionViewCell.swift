//
//  ProfileDetailImageCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import UIKit

final class ProfileDetailImageCollectionViewCell: UICollectionViewCell {
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let imageSize = CGSize(width: 254, height: 254)
  }
  
  private let neumorphismBox = NeumorphismBox(shadowColor: Colors.yellow.color.cgColor, shadowOpacity: 0.15, shadowRadius: 8)
  
  private let personalityTypeLabel = UILabel().then {
    $0.text = "늘 행복한 동글이"
    $0.textColor = Colors.yellow.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 22)
  }
  
  private let personalityImageView = UIImageView().then {
    $0.image = Images.illEnterroom.image // 임시로 이렇게 지정 (서버 통신 작업 후 수정 예정)
  }
  
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
  
  private func render(){
    self.addSubViews([personalityTypeLabel, neumorphismBox, personalityImageView])
    
    personalityTypeLabel.snp.makeConstraints {make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(28)
    }
    
    neumorphismBox.snp.makeConstraints { make in
      make.center.equalTo(personalityImageView.snp.center)
      make.leading.trailing.equalToSuperview().inset(60)
      make.height.equalTo(neumorphismBox.snp.width)
    }
    
    personalityImageView.snp.makeConstraints {make in
      make.centerX.equalTo(personalityTypeLabel)
      make.top.equalTo(personalityTypeLabel.snp.bottom).offset(38)
      make.width.height.equalTo(Size.imageSize)
    }
  }
  
//  func setData(_ dataPack: ProfileTestResultDataPack){
//    self.userNameLabel.text =  dataPack.userNameLabel
//    self.personalityTypeLabel.text = dataPack.personalityTypeLabel
//    self.personalityImageView.urlToImage(urlString: dataPack.personalityImageURL)
//  }
}
