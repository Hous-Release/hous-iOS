//
//  MainHomeProfileCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/09.
//

import UIKit

class MainHomeProfileCollectionViewCell: UICollectionViewCell {
  //MARK: - Vars & Lets
  static let identifier = "MainHomeProfileCollectionViewCell"
  
  //MARK: - UI Components
  private let profileBackgroundImageView = UIImageView().then {
    $0.image = Images.profileRed.image
  }
  
  private let homieNameLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .left
    $0.textColor = .black
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
    addSubview(profileBackgroundImageView)
    profileBackgroundImageView.addSubview(homieNameLabel)
    
    profileBackgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    homieNameLabel.snp.makeConstraints { make in
      make.leading.greaterThanOrEqualToSuperview().offset(13)
      make.top.greaterThanOrEqualToSuperview().offset(8)
    }
  }
  
  func setProfileCell(userNickname: String) {
    homieNameLabel.text = userNickname
  }
  
}
