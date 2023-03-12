//
//  ProfileDetailRecommendCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import UIKit

final class ProfileDetailRecommendCollectionViewCell: UICollectionViewCell {
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let stackViewHeight = 202
  }

  private let profileTestResultRecommendStackView = UIStackView().then {
    $0.distribution = .fillProportionally
    $0.alignment = .fill
    $0.axis = .horizontal
    $0.spacing = 4
  }

  private var badRecommendView = ProfileRecommendBoxView(personalityName: "", imageURL: "", cellType: .bad)

  private var goodRecommendView = ProfileRecommendBoxView(personalityName: "", imageURL: "", cellType: .good)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI() {
    self.backgroundColor = .white
  }

  private func render() {

    profileTestResultRecommendStackView.addArrangedSubviews(badRecommendView, goodRecommendView)
    self.addSubView(profileTestResultRecommendStackView)
    profileTestResultRecommendStackView.snp.makeConstraints {make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.equalToSuperview().offset(2)
      make.height.equalTo(Size.stackViewHeight)
    }
  }

  func bind(_ data: ProfileDetailModel) {
    profileTestResultRecommendStackView.removeFullyAllArrangedSubviews()

    badRecommendView = ProfileRecommendBoxView(
      personalityName: data.badPersonalityName, imageURL: data.badPersonalityImageURL, cellType: .bad)
    goodRecommendView = ProfileRecommendBoxView(
      personalityName: data.goodPersonalityName, imageURL: data.goodPersonalityImageURL, cellType: .good)
    render()
  }
}
