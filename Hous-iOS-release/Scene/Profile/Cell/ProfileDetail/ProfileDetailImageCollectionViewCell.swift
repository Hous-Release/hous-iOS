//
//  ProfileDetailImageCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import UIKit
import Kingfisher

final class ProfileDetailImageCollectionViewCell: UICollectionViewCell {
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let imageSize = CGSize(width: 254, height: 254)
  }
  
  private let neumorphismBox = NeumorphismBox(shadowColor: Colors.black.color.cgColor, shadowOpacity: 0.15, shadowRadius: 8)
  
  private let personalityTypeLabel = UILabel().then {
    $0.text = ""
    $0.textColor = Colors.yellow.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 22)
  }
  
  private let personalityImageView = UIImageView()
  
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
  
  func bind(_ data: ProfileDetailModel) {
    personalityTypeLabel.text = data.name
    personalityImageView.kf.setImage(with: URL(string: data.imageURL))
    switch data.personalityType {
    case .red:
      neumorphismBox.layer.shadowColor = Colors.red.color.cgColor
      personalityTypeLabel.textColor = Colors.red.color
    case .blue:
      neumorphismBox.layer.shadowColor = Colors.blue.color.cgColor
      personalityTypeLabel.textColor = Colors.blue.color
    case .green:
      neumorphismBox.layer.shadowColor = Colors.green.color.cgColor
      personalityTypeLabel.textColor = Colors.green.color
    case .purple:
      neumorphismBox.layer.shadowColor = Colors.purple.color.cgColor
      personalityTypeLabel.textColor = Colors.purple.color
    case .yellow:
      neumorphismBox.layer.shadowColor = Colors.yellow.color.cgColor
      personalityTypeLabel.textColor = Colors.yellow.color
    default:
      break
    }

  }
}
