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
import Kingfisher

final class ProfileMainImageCollectionViewCell: UICollectionViewCell {
  
  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileActionControl>()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var profileMainImage = AnimationView()
  
  
  private var badgeImage = UIImageView().then {
    $0.image = Images.noBadge.image
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


  private func configUI() {

  }
  
  private func render() {
    addSubViews([
      badgeImage,
      titleLabel,
      badgeLabel,
      alarmButton,
      settingButton])
    
    
    badgeImage.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-48)
      make.trailing.equalToSuperview().offset(-50)
      make.width.height.equalTo(100)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(62)
      make.leading.equalToSuperview().offset(24)
    }
    
    badgeLabel.snp.makeConstraints { make in
      make.top.equalTo(badgeImage.snp.bottom).offset(8)
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
  
  private func animatedRender(data: ProfileModel) {
    if data.isEmptyView {
      self.backgroundColor = Colors.blueL2.color
      profileMainImage.removeFromSuperview()
      profileMainImage = AnimationView.init(name: "empty_profile")
      addSubview(profileMainImage)
      profileMainImage.snp.makeConstraints { make in
        make.top.bottom.leading.trailing.equalToSuperview()
        make.height.equalTo(254)
        make.width.equalTo(Size.screenWidth)
      }
      self.sendSubviewToBack(profileMainImage)
      profileMainImage.loopMode = .loop
      profileMainImage.play()
      
    } else {
      var selectedColor: UIColor
      var selectedLottie: AnimationView
      
      switch data.personalityColor {
      case .red:
        selectedColor = Colors.redB1.color
        if let _ = data.badgeLabel {
          selectedLottie = AnimationView.init(name: "tri_yes")
        } else {
          selectedLottie = AnimationView.init(name: "tri_no")
        }
      case .blue:
        selectedColor = Colors.blueL1.color
        if let _ = data.badgeLabel {
          selectedLottie = AnimationView.init(name: "squ_yes")
        } else {
          selectedLottie = AnimationView.init(name: "squ_no")
        }
        
      case .yellow:
        selectedColor = Colors.yellowB1.color
        if let _ = data.badgeLabel {
          selectedLottie = AnimationView.init(name: "cir_yes")
        } else {
          selectedLottie = AnimationView.init(name: "cir_no")
        }
        
      case .green:
        selectedColor = Colors.greenB1.color
        if let _ = data.badgeLabel {
          selectedLottie = AnimationView.init(name: "hex_yes")
        } else {
          selectedLottie = AnimationView.init(name: "hex_no")
        }
        
      case .purple:
        selectedColor = Colors.purpleB1.color
        if let _ = data.badgeLabel {
          selectedLottie = AnimationView.init(name: "pen_yes")
        } else {
          selectedLottie = AnimationView.init(name: "pen_no")
        }
        
      default:
        return
      }
      
      self.backgroundColor = selectedColor
      profileMainImage.removeFromSuperview()
      profileMainImage = selectedLottie
      addSubview(profileMainImage)
      profileMainImage.snp.makeConstraints { make in
        make.top.bottom.leading.trailing.equalToSuperview()
        make.height.equalTo(254)
        make.width.equalTo(Size.screenWidth)
      }
      self.sendSubviewToBack(profileMainImage)
      profileMainImage.play()
    }
  }
  
  private func transferToViewController() {
    self.alarmButton.rx.tap
      .bind (onNext:{ [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabAlarm)
      })
      .disposed(by: disposeBag)
    
    self.settingButton.rx.tap
      .bind (onNext:{ [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabSetting)
      })
      .disposed(by: disposeBag)
    
     badgeImage.rx.tapGesture()
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabBadge)
      })
      .disposed(by: disposeBag)
  }
  
  func bind(_ data: ProfileModel) {
    animatedRender(data: data)
    if let imageURL = data.badgeImageURL{
      badgeImage.kf.setImage(with: URL(string: imageURL))
    } else {
      badgeImage.image = Images.noBadge.image
    }
    badgeLabel.text = data.badgeLabel ?? "내 대표 배지"
  }
}
