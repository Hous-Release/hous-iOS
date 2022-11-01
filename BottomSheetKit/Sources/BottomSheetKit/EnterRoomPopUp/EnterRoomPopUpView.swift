//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation
import UIKit
import AssetKit

internal final class EnterRoomPopUpView: UIView {

  private typealias SpoqaHanSansNeo = Fonts.SpoqaHanSansNeo

  private enum Constant {
    static let imageTopMargin: CGFloat = 52
    static let cancelButtonSize: CGFloat = 24
    static let verticalMargin: CGFloat = 20
    static let imageHorizontalMargin: CGFloat = 62
    static let horizontalMargin: CGFloat = 20
    static let itemTopMargin: CGFloat = 16
    static let buttonHeight: CGFloat = 42
    static let containerHorizontalMargin: CGFloat = 86
    static let containerHeight: CGFloat = 32
    static let itemHorizontalMargin: CGFloat = 8
  }

  private let rootView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    view.backgroundColor = .white
    return view
  }()

  internal lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setImage(Images.icClose.image, for: .normal)
    return button
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    return imageView
  }()

  private let nameContainerView: UIView = UIView()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "nameLabel"
    label.font = SpoqaHanSansNeo.bold.font(size: 24)
    label.textColor = Colors.black.color
    return label
  }()

  private let 님이Label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.lineBreakStrategy = .hangulWordPriority
    label.textAlignment = .center
    label.textColor = Colors.g5.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    label.text = "님이"
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.lineBreakStrategy = .hangulWordPriority
    label.textAlignment = .center
    label.textColor = Colors.g5.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    label.textAlignment = .center
    label.text = "초대한 방에 참여할까요?"
    return label
  }()


  internal lazy var actionButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 8
    button.setTitle("actionButton", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.backgroundColor = Colors.blue.color
    button.setTitleColor(Colors.white.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 16)
    return button
  }()


  internal init(_ model: ImagePopUpModel) {
    super.init(frame: .zero)
    setupViews()
    configure(model)
  }

  required init?(coder: NSCoder) {
    fatalError("CopyCodePopUpView is not implemented")
  }
}

extension EnterRoomPopUpView {

  private func configure(_ model: ImagePopUpModel) {

    actionButton.setTitle(model.actionText, for: .normal)
    nameLabel.text = model.text

    // TODO: - Image
//    imageView.image =
  }

  private func setupViews() {
    addSubview(rootView)

    rootView.addSubview(cancelButton)
    rootView.addSubview(imageView)

    rootView.addSubview(nameContainerView)


    nameContainerView.addSubview(nameLabel)
    nameContainerView.addSubview(님이Label)

    rootView.addSubview(subtitleLabel)
    rootView.addSubview(actionButton)


    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    cancelButton.snp.makeConstraints { make in
      make.width.height.equalTo(Constant.cancelButtonSize)
      make.top.equalToSuperview().inset(Constant.verticalMargin)
      make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
    }

    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
        .inset(Constant.imageTopMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.imageHorizontalMargin).priority(.high)
      make.height.equalTo(imageView.snp.width)
    }
    nameContainerView.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom)
        .offset(Constant.itemTopMargin)
      make.leading.trailing.equalToSuperview().inset(Constant.containerHorizontalMargin)
      make.height.equalTo(Constant.containerHeight)
    }
    nameLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
    }
    님이Label.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel.snp.trailing).offset(Constant.itemHorizontalMargin)
      make.bottom.equalToSuperview().inset(Constant.itemTopMargin / 8)
    }
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(nameContainerView.snp.bottom)
        .offset(Constant.itemTopMargin / 4)
      make.centerX.equalToSuperview()
    }

    actionButton.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(Constant.verticalMargin)
      make.leading.trailing.equalToSuperview()
        .inset(Constant.horizontalMargin)
      make.height.equalTo(Constant.buttonHeight)

    }
  }
}
