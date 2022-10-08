//
//  ProfileMainImageCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import UIKit

final class ProfileMainImageCollectionViewCell: UICollectionViewCell {
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var profileMainImage = UIImageView().then {
    $0.image = Images.profileRed.image
  }
  
  private var bedgeImage = UIImageView().then {
    $0.image = Images.badgeLock.image
  }
  
  private var titleLabel = UILabel().then {
    $0.text = "내 프로필"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 22)
    $0.textAlignment = .left
  }
  
  var bedgeLabel = UILabel().then {
    $0.text = "왕짱파워똑똑이"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
    $0.textAlignment = .center
  }
  
  private let alarmButton = UIButton().then {
    $0.setImage(Images.icAlarm.image, for: .normal)
  }
  
  private let settingButton = UIButton().then {
    $0.setImage(Images.icSetting.image, for:.normal)
  }
  
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
    setData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .red
  }
  
  private func render() {
    print("Cell Render")
    [profileMainImage,
     bedgeImage,
     titleLabel,
     bedgeLabel,
     alarmButton,
     settingButton].forEach { addSubview($0) }
    
    profileMainImage.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(254)
      make.width.equalTo(Size.screenWidth)
    }
    
    bedgeImage.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-48)
      make.trailing.equalToSuperview().offset(-50)
      make.width.equalTo(100)
      make.height.equalTo(100)
      
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(62)
      make.leading.equalToSuperview().offset(24)
    }

    bedgeLabel.snp.makeConstraints { make in
      make.top.equalTo(bedgeImage.snp.bottom).offset(8)
      make.centerX.equalTo(bedgeImage.snp.centerX)
    }

    alarmButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(62)
      make.trailing.equalToSuperview().offset(60)
    }
    
    settingButton.snp.makeConstraints { make in
      make.centerY.equalTo(alarmButton.snp.centerY)
      make.leading.equalTo(alarmButton.snp.trailing).offset(12)
    }
  }
  
  func setData() {
    
  }
  
}






