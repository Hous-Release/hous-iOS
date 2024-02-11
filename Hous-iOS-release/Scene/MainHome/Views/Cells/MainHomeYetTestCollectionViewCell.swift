//
//  MainHomeYetTestCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2/11/24.
//

import UIKit
import RxSwift

final class MainHomeYetTestCollectionViewCell: UICollectionViewCell {
  private let backgroundImageView = UIImageView().then {
    $0.image = Images.blurProfileBackground.image
    $0.contentMode = .scaleAspectFill
  }

  private let descriptionLabel = UILabel().then {
    $0.text = "아직 나의 성향을 확인해보지 않았어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textColor = Colors.white.color
  }

  let testButton = UIButton().then {
    $0.setTitle("검사해보러 가기", for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.backgroundColor = Colors.white.color
    $0.setTitleColor(Colors.black.color, for: .normal)
    $0.layer.cornerRadius = 8
  }

  var disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setHierarchy()
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setHierarchy() {
    contentView.addSubview(backgroundImageView)
    [descriptionLabel, testButton].forEach {
      backgroundImageView.addSubview($0)
    }

  }

  private func setLayout() {
    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(72)
    }

    testButton.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(22)
      make.bottom.equalToSuperview().inset(68)
    }
  }

}
