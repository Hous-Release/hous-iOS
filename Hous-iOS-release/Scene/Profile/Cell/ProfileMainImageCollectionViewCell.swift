//
//  ProfileMainImageCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

protocol profileMainImageCellDelegate: AnyObject {
  func didTabSetting()
  func didTabAlarm()
}

final class ProfileMainImageCollectionViewCell: UICollectionViewCell {
  
  private let disposeBag: DisposeBag = DisposeBag()
  weak var delegate: profileMainImageCellDelegate?
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var profileMainImage: AnimationView = .init(name:"profileRedlottie").then {
    $0.play()
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
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = Colors.redProfile.color
  }
  
  private func render() {
    addSubViews([
      profileMainImage,
      bedgeImage,
      titleLabel,
      bedgeLabel,
      alarmButton,
      settingButton])
    
    profileMainImage.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(254)
      make.width.equalTo(Size.screenWidth)
    }
    
    bedgeImage.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-32)
      make.trailing.equalToSuperview().offset(-45)
      make.width.height.equalTo(110)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(62)
      make.leading.equalToSuperview().offset(24)
    }
    
    bedgeLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-20)
      make.height.equalTo(20)
      make.centerX.equalTo(bedgeImage.snp.centerX)
    }
    
    alarmButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(62)
      make.trailing.equalToSuperview().offset(-60)
    }
    
    settingButton.snp.makeConstraints { make in
      make.centerY.equalTo(alarmButton.snp.centerY)
      make.leading.equalTo(alarmButton.snp.trailing).offset(12)
    }
  }
  
  private func transferToViewController() {
    self.alarmButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.delegate?.didTabAlarm()
      }
      .disposed(by: disposeBag)
    
    self.settingButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.delegate?.didTabSetting()
      }
      .disposed(by: disposeBag)
  }
  
  func bind(_ data: ProfileModel) {
    bedgeLabel.text = data.bedgeLabel
  }
}
