//
//  ProfileSettingListView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileSettingListView: UIView {

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }

  private let disposeBag: DisposeBag = DisposeBag()

  private let listImage = UIImageView()

  private let listTextLabel = UILabel().then {
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }

  let forwardButtonImage = UIImageView().then {
    $0.image = Images.icNext.image
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(image: UIImage, text: String) {
    self.init(frame: .zero)
    self.listImage.image = image
    self.listTextLabel.text = text
  }

  private func setup() {
    self.backgroundColor = .white
  }

  private func render() {
    self.addSubViews([listImage, listTextLabel, forwardButtonImage])

    listImage.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(24)
    }

    listTextLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(listImage.snp.trailing).offset(12)
    }

    forwardButtonImage.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-16)
    }

  }
}
