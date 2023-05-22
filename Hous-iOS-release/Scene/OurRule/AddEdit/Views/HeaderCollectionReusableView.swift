//
//  HeaderCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {

  var plusButtonClousre: (() -> Void)?

  private let titleLabel = HousLabel(
    text: StringLiterals.OurRule.AddEditView.photo,
    font: Fonts.SpoqaHanSansNeo.medium.font(size: 14),
    textColor: Colors.black.color)

  private lazy var plusButton: UIButton = {
    var config = UIButton.Configuration.plain()
    config.baseBackgroundColor = .clear
    var titleAttr = AttributedString(StringLiterals.ButtonTitle.Rule.addPhoto)
    titleAttr.font = Fonts.SpoqaHanSansNeo.bold.font(size: 13)
    config.attributedTitle = titleAttr
    config.image = Images.addCircleOn.image
    config.imagePlacement = .leading
    config.imagePadding = 8
    config.contentInsets = .zero
    let button = UIButton(configuration: config)
    button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
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
  @objc func handleTap() {
    plusButtonClousre?()
  }
}
