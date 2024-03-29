//
//  ResignGuideCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit

class ResignGuideCollectionViewCell: UICollectionViewCell {

  enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }

  let mainView = UIView()

  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fillProportionally
    $0.spacing = 16
  }

  let titleLabel = UILabel().then {
    $0.text = "정말 탈퇴하시겠어요?"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.textAlignment = .center
  }

  let imageView = UIImageView().then {
    $0.image = Images.resign.image
    $0.makeRounded(cornerRadius: 8)
    $0.clipsToBounds = true
  }

  let subTitleLabel = UILabel().then {
    $0.text = "지금까지 Hous- 를 이용해주셔서 감사합니다"
    $0.textColor = Colors.g7.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textAlignment = .center
  }

  let guideLabel = UILabel().then {
    $0.text = "회원을 탈퇴하면 탈퇴 신청 즉시\n회원님의 개인정보는 삭제되며 복구될 수 없습니다.\n\n회원님께서 불편하셨던 점이나 불만사항을\n알려주시면 적극 반영해서 고객님의 불편함을\n해결해 드리도록 노력하는 Hous-가 되겠습니다."
    $0.textColor = Colors.g4.color
    $0.numberOfLines = 6
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

extension ResignGuideCollectionViewCell {

  private func render() {

    addSubView(mainView)
    mainView.addSubView(stackView)

    mainView.snp.makeConstraints { make in
      make.width.equalTo(Size.screenWidth)
      make.edges.equalToSuperview()
    }

    stackView.addArrangedSubviews(
      titleLabel,
      imageView,
      subTitleLabel,
      guideLabel,
      separateView
    )

    stackView.snp.makeConstraints { make in
      make.trailing.leading.equalToSuperview().inset(24)
      make.top.bottom.equalToSuperview()
    }

    separateView.snp.makeConstraints { make in
      make.height.equalTo(1)
    }
  }
}
