//
//  RepresentingBadgeCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/08.
//

import UIKit
import RxSwift
import Kingfisher

class RepresentingBadgeCollectionViewCell: UICollectionViewCell {
  
  let badgeView = UIImageView().then {
    $0.backgroundColor = .white
  }
  
  private let titleLabel = UILabel().then {
    $0.textColor = Colors.white.color
    $0.textAlignment = .center
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
  }
  
  private let emptyBadgeLabel = UILabel().then {
    $0.numberOfLines = 3
    $0.textAlignment = .center
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.isHidden = false
    $0.text = "눌러서\n대표 배지를\n설정해보세요"
    $0.textColor = Colors.g4.color
  }
  
  private let starImageView1 = UIImageView().then {
    $0.image = Images.star.image
  }
  
  private let starImageView2 = UIImageView().then {
    $0.image = Images.star.image
  }
  
  private let starImageView3 = UIImageView().then {
    $0.image = Images.star.image
  }
  
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    badgeView.makeRounded(cornerRadius: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func configUI() {
    contentView.backgroundColor = Colors.g7.color
    
    
    contentView.addSubViews([
      badgeView,
      titleLabel,
      starImageView1,
      starImageView2,
      starImageView3
    ])
    
    badgeView.addSubview(emptyBadgeLabel)
    
    
    badgeView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(contentView).offset(20)
      make.size.equalTo(100)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalTo(badgeView)
      make.top.equalTo(badgeView.snp.bottom).offset(10)
    }
    
    emptyBadgeLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    starImageView1.snp.makeConstraints { make in
      make.centerY.equalTo(badgeView)
      make.leading.equalToSuperview().offset(80)
    }
    
    starImageView2.snp.makeConstraints { make in
      make.top.equalTo(badgeView.snp.bottom).inset(10)
      make.leading.equalTo(badgeView.snp.trailing).offset(35)
    }
    
    starImageView3.snp.makeConstraints { make in
      make.top.equalTo(badgeView)
      make.leading.equalTo(badgeView.snp.trailing).inset(4)
    }
  }
  
  func setRepresntingBadgeCellData(viewModel: RepresentingBadgeViewModel) {
    guard let url = URL(string: viewModel.imageURL) else { return }
    badgeView.kf.setImage(with: url)
//    badgeView.image = viewModel.image
    if viewModel.title.count > 0 {
      titleLabel.text = viewModel.title
      emptyBadgeLabel.isHidden = true
    } else {
      titleLabel.isHidden = true
      emptyBadgeLabel.isHidden = false
    }
  }
  
}
