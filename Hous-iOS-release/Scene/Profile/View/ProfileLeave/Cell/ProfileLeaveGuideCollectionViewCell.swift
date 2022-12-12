//
//  ProfileLeaveGuideCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/12.
//

import UIKit

class ProfileLeaveGuideCollectionViewCell: UICollectionViewCell {

  private enum Size {
    static let alarmBackgroundHeight: CGFloat = 38
  }

  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fillProportionally
    $0.spacing = 16
  }

  let imageView = UIImageView().then {
    $0.image = Images.resign.image
    $0.makeRounded(cornerRadius: 8)
    $0.clipsToBounds = true
  }

  let labelsView = UIView()

  let titleLabel = UILabel().then {
    $0.text = "안녕... 정든 우리 Hous-..."
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.textAlignment = .center
  }

  let alarmBackgroundView = UIView().then {
    $0.backgroundColor = Colors.redB1.color
    $0.makeRounded(cornerRadius: Size.alarmBackgroundHeight / 2)
  }

  let alarmLabel = UILabel().then {
    $0.text = "방을 탈퇴하면 내게만 배정된 to-do가 삭제돼요!"
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .center
  }

  let guideLabel = UILabel().then {
    $0.text = "탈퇴 전에 이 페이지를 캡쳐해서 호미들에게 공유하고,\n담당자 교체를 제안하면 어떨까요?"
    $0.textColor = Colors.g5.color
    $0.numberOfLines = 2
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
    $0.textAlignment = .center
  }

  let separateView = UIView().then {
    $0.backgroundColor = Colors.g1.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileLeaveGuideCollectionViewCell {

  private func render() {

    addSubView(stackView)
    stackView.addArrangedSubviews(
      imageView,
      labelsView,
      separateView
    )
    labelsView.addSubViews([
      titleLabel,
      alarmBackgroundView,
      guideLabel
    ])
    alarmBackgroundView.addSubView(alarmLabel)

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.trailing.equalToSuperview()
    }

    alarmBackgroundView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview()
    }

    alarmLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    guideLabel.snp.makeConstraints { make in
      make.top.equalTo(alarmBackgroundView.snp.bottom).offset(12)
      make.leading.trailing.bottom.equalToSuperview()
    }

    stackView.snp.makeConstraints { make in
      make.trailing.leading.equalToSuperview().inset(24)
      make.top.bottom.equalToSuperview()
    }

    separateView.snp.makeConstraints { make in
      make.height.equalTo(1)
    }
  }
}
