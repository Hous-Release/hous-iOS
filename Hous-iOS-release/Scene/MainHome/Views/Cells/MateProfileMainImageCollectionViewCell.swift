//
//  MateProfileMainImageCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import RxGesture
import Kingfisher

final class MateProfileMainImageCollectionViewCell: UICollectionViewCell {

  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<MateActionControl>()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }

  // MARK: UI Components

  private var profileMainImage = UIImageView()

  private let navigationBackButton = UIButton().then {
    $0.setImage(Images.icBack1.image, for: .normal)
  }

  private let nameView = MateProfileNameView()

  private let nameLabel = UILabel().then {
    $0.text = "이름"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.textColor = Colors.black.color
  }

  private let homieLabel = UILabel().then {
    $0.text = "호미"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 16)
    $0.textColor = Colors.g4.color
  }

  // MARK: Initializer

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

  // MARK: UI Set

  private func configUI() {

  }

  private func render() {
    addSubViews([
       profileMainImage,
       navigationBackButton,
       nameView,
       nameLabel,
       homieLabel])

    profileMainImage.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(254)
      make.width.equalTo(Size.screenWidth)
    }

    navigationBackButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(64)
      make.leading.equalToSuperview().offset(24)
      make.width.height.equalTo(28)
    }

    nameView.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(4)
      make.leading.width.equalToSuperview()
      make.height.equalTo(41)
    }

    nameLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().offset(22)
    }

    homieLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalTo(nameLabel.snp.trailing).offset(4)
    }
  }

  func bind(_ data: ProfileModel) {
    switch data.personalityColor {
    case .red:
      profileMainImage.image = Images.illTri.image
    case .blue:
      profileMainImage.image = Images.illSqu.image
    case .green:
      profileMainImage.image = Images.illHex.image
    case .yellow:
      profileMainImage.image = Images.illCir.image
    case .purple:
      profileMainImage.image = Images.illPen.image
    case .none:
      break
    }

    nameLabel.text = data.userName
  }

  private func transferToViewController() {
    self.navigationBackButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabBack)
      }
      .disposed(by: disposeBag)
  }
}
