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
import RxGesture

final class ProfileMainImageCollectionViewCell: UICollectionViewCell {
  
  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileActionControl>()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var profileMainImage: AnimationView = .init(name:"profileRedlottie").then {
    $0.play()
  }
  
  private var badgeImage = UIImageView().then {
    $0.image = Images.badgeLock.image
  }
  
  private var titleLabel = UILabel().then {
    $0.text = "내 프로필"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 22)
    $0.textAlignment = .left
  }
  
  var badgeLabel = UILabel().then {
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

  override func prepareForReuse() {
   super.prepareForReuse()
   disposeBag = DisposeBag()
   transferToViewController()
 }
  
  //MARK: UI Set

  // TODO: - 인영에게 Zeplin 업로드 요청하고 색깔 export 해주세요.
  private func configUI() {
//    self.backgroundColor = Colors.redProfile.color
  }
  
  private func render() {
    addSubViews([
      badgeImage,
      titleLabel,
      badgeLabel,
      alarmButton,
      settingButton])
    
    
    badgeImage.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-32)
      make.trailing.equalToSuperview().offset(-45)
      make.width.height.equalTo(110)
    }
    
//    badgeImage.rx.tapGesture().asObservable()
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(62)
      make.leading.equalToSuperview().offset(24)
    }
    
    badgeLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-20)
      make.height.equalTo(20)
      make.centerX.equalTo(badgeImage.snp.centerX)
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
  
  private func animatedRender(isEmptyView: Bool) {
    if isEmptyView {
      self.backgroundColor = Colors.g1.color
    } else {
      addSubview(profileMainImage)
      profileMainImage.snp.makeConstraints { make in
        make.top.bottom.leading.trailing.equalToSuperview()
        make.height.equalTo(254)
        make.width.equalTo(Size.screenWidth)
      }
      profileMainImage.currentProgress = 0
      profileMainImage.play()
    }
  }
  
  private func transferToViewController() {
    self.alarmButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabAlarm)
      }
      .disposed(by: disposeBag)
    
    self.settingButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabSetting)
      }
      .disposed(by: disposeBag)
  }
  
  func bind(_ data: ProfileModel) {
    animatedRender(isEmptyView: data.isEmptyView)
    badgeLabel.text = data.badgeLabel
  }
}
