//
//  HeaderCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit
import HousUIComponent
import RxSwift

final class HeaderCollectionReusableView: UICollectionReusableView {

  let plusButtonTapSubject = PublishSubject<Void>()

  private let disposeBag = DisposeBag()

  private let titleLabel = HousLabel(
    text: StringLiterals.OurRule.AddEditView.photo,
    font: .B2,
    textColor: Colors.black.color)

  private lazy var plusButton: UIButton = {
    var config = UIButton.Configuration.plain()
    config.baseBackgroundColor = .clear
    var titleAttr = AttributedString(StringLiterals.ButtonTitle.Rule.addPhoto)
    titleAttr.font = Fonts.SpoqaHanSansNeo.bold.font(size: 13)
    config.attributedTitle = titleAttr
    config.image = Images.addCircleOn.image.withRenderingMode(.alwaysTemplate)
    config.imagePlacement = .leading
    config.imagePadding = 8
    config.contentInsets = .zero
    let button = UIButton(configuration: config)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setLayout() {
    self.addSubview(titleLabel)
    self.addSubview(plusButton)

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
    }

    plusButton.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.bottom.equalToSuperview().inset(12)
    }

  }
}

extension HeaderCollectionReusableView {
  func bind() {
    plusButton.rx.tap
      .subscribe(onNext: { _ in
        self.plusButtonTapSubject.onNext(())
      })
      .disposed(by: disposeBag)
  }

  func updateButtonState(isEnable: Bool) {
    plusButton.isEnabled = isEnable
    plusButton.tintColor = isEnable ? Colors.blue.color : Colors.g4.color
  }
}
