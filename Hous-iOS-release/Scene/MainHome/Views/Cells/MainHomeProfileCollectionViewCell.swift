//
//  MainHomeProfileCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/09.
//

import UIKit

class MainHomeProfileCollectionViewCell: UICollectionViewCell {
  //MARK: - Vars & Lets
  //MARK: - UI Components
  private let profileBackgroundImageView = UIImageView().then {
    $0.image = Images.profileRed.image
  }
  
  private let homieNameLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .left
    $0.textColor = Colors.black.color
  }
  
  private let nameLabelBackgroundView = UIView().then {
    $0.backgroundColor = .white
    $0.roundCorners(cornerRadius: 8, maskedCorners: .layerMaxXMaxYCorner)
  }
  
  //MARK: - Life Cycles
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI() {
    contentView.addSubview(profileBackgroundImageView)
    profileBackgroundImageView.addSubview(nameLabelBackgroundView)
    nameLabelBackgroundView.addSubview(homieNameLabel)
    
    profileBackgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    nameLabelBackgroundView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.trailing.greaterThanOrEqualToSuperview().inset(94)
      make.bottom.greaterThanOrEqualToSuperview().inset(63)
    }
    
    homieNameLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  
  func setProfileCell(homieColor: String, userNickname: String) {
    let factory = HomieFactory.makeHomie(type: HomieColor(rawValue: homieColor) ?? .GRAY)
    profileBackgroundImageView.image = factory.profileBackgroundImage
    homieNameLabel.text = userNickname
  }
  
}
