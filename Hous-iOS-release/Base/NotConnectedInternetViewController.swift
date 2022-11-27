//
//  NotConnectedInternetViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/28.
//

import AssetKit
import SnapKit
import UIKit


final class NotConnectedInternetViewController: UIViewController {

  private struct Constant {
    static let topMargin: CGFloat = 125
    static let horizontalMarginForImage: CGFloat = 68
    static let horizontalMarginForLabel: CGFloat = 58
    static let buttonSize: CGSize = CGSize(width: 182, height: 44)
    static let topMarginForTitleLabel: CGFloat = 20
    static let topMarginForSubtitleLabel: CGFloat = 12
    static let topMarginForButton: CGFloat = 40
  }

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    label.text = "인터넷에 연결되어 있지 않아요!"
    label.textColor = Colors.black.color
    label.textAlignment = .center
    return label
  }()
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    label.text = "Hous-를 사용하려면 인터넷 연결이 필요해요.\nWi-Fi를 다시 한 번 확인해주세요!"
    label.numberOfLines = 2
    label.textColor = Colors.g5.color
    label.textAlignment = .center
    return label
  }()

  private lazy var retryButton: UIButton = {
    let button = UIButton()
    button.setTitle("다시 시도하기", for: .normal)
    button.setTitleColor(Colors.white.color, for: .normal)
    button.backgroundColor = Colors.blue.color
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    button.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
    return button
  }()


  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  @objc
  private func didTapRetryButton() {
    self.dismiss(animated: true)
  }

  private func setupViews() {
    view.addSubView(imageView)
    view.addSubView(titleLabel)
    view.addSubView(subtitleLabel)
    view.addSubView(retryButton)

    imageView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .inset(Constant.horizontalMarginForImage)
        .priority(.high)
      make.height.equalTo(self.imageView.snp.width)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constant.topMargin)
    }
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMarginForLabel)
      make.top.equalTo(imageView.snp.bottom).offset(Constant.topMarginForTitleLabel)
    }
    subtitleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMarginForLabel)
      make.top.equalTo(titleLabel.snp.bottom).offset(Constant.topMarginForSubtitleLabel)
    }
    retryButton.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(Constant.topMarginForButton)
      make.centerX.equalToSuperview()
      make.size.equalTo(Constant.buttonSize)
    }
  }
}
