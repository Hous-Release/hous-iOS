//
//  BadgeCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/08.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
  
  private let badgeImageView = UIImageView().then {
    $0.backgroundColor = .clear
  }
  
  private lazy var blurView = UIView().then {
    $0.backgroundColor = Colors.g7.color.withAlphaComponent(0.8)
  }
  
  private let representLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.textColor = Colors.white.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.text = "대표배지로\n설정됨"
    $0.isHidden = true
  }
  
  private let badgeTitleLabel = UILabel().then {
    $0.text = "title"
    $0.textAlignment = .center
    $0.textColor = Colors.g7.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
  }
  
  private let badgeDescriptionLabel = UILabel().then {
    $0.text = "description"
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.g4.color
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    badgeImageView.makeShadow(color: .black, opacity: 0.4, offset: CGSize(width: 0, height: 0), radius: 10)
    badgeImageView.makeRounded(cornerRadius: nil)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI() {
    contentView.addSubViews([
      badgeImageView,
      badgeTitleLabel,
      badgeDescriptionLabel
    ])
    
    badgeImageView.addSubViews([
      blurView,
      representLabel
    ])
    
    badgeImageView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.size.equalTo(80)
    }
    
    blurView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    representLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    badgeTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(badgeImageView.snp.bottom).offset(12)
      make.centerX.equalTo(badgeImageView)
    }
    
    badgeDescriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(badgeTitleLabel.snp.bottom).offset(2)
      make.centerX.equalTo(badgeImageView)
    }
  }
    
  func setRoomBadgeCellData(viewModel: RoomBadgeViewModel) {
    badgeTitleLabel.text = viewModel.title
    badgeDescriptionLabel.text = viewModel.description
    
    if viewModel.isAcquired {
      badgeImageView.image = viewModel.image
    } else {
      badgeImageView.image = Images.badgeLock.image
    }
    
    if viewModel.isRepresenting {
      blurView.isHidden = false
      representLabel.isHidden = false
    } else {
      blurView.isHidden = true
      representLabel.isHidden = true
    }
  }
  
}
