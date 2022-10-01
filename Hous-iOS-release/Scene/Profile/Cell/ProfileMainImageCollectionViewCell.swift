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
    $0.font = Fonts.SpoqaHanSansNeo.bold.fo,nt(size: 22)
    $0.textAlignment = .left
  }
  
  private var bedgeLabel = UILabel().then {
    $0.text = "왕짱파워똑똑이"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size:13)
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
    self.backgroundColor = .white
  }
  
  private func render() {
    self.addSubViews([profileMainImage,
                      bedgeImage,
                      titleLabel,
                      bedgeLabel,
                      alarmButton,
                      settingButton])
    
    profileMainImage.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
    
    bedgeImage.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(106)
      make.bottom.equalToSuperview().offset(48)
      make.trailing.equalToSuperview().offset(50)
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






