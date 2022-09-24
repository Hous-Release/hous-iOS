//
//  PagingView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/23.
//

import UIKit

import SnapKit
import Then

final class PagingView: UIView {

  var navigationBar = NavBarWithBackButtonView(title: "", rightButtonText: "건너뛰기").then {
    $0.rightButton.setTitleColor(Colors.g4.color, for: .normal)
    $0.rightButton.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.rightButton.isHidden = false
    $0.backButton.isHidden = true
  }

  let pagingCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      $0.collectionViewLayout = layout

      $0.showsHorizontalScrollIndicator = false
      $0.isPagingEnabled = true
      $0.register(cell: PagingCell.self)
    }
  let pageControl = UIPageControl().then {
    $0.numberOfPages = 4
    $0.currentPage = 0
    $0.isEnabled = false
    $0.pageIndicatorTintColor = Colors.g3.color
    $0.currentPageIndicatorTintColor = Colors.blue.color
  }
  var nextButton = UIButton().then {
    $0.setTitle("다음으로", for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.titleLabel?.textColor = Colors.white.color
    $0.setBackgroundColor(Colors.g4.color, for: .disabled)
    $0.setBackgroundColor(Colors.blue.color, for: .normal)
    $0.isHidden = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    addSubViews([navigationBar, pagingCollectionView, pageControl, nextButton])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    pagingCollectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.bottom.equalTo(nextButton.snp.top)
      make.leading.trailing.equalToSuperview()
    }

    nextButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(86)
    }

    pageControl.snp.makeConstraints { make in
      make.centerX.equalTo(nextButton.snp.centerX)
      make.centerY.equalTo(nextButton.snp.centerY).multipliedBy(0.96)
      make.width.greaterThanOrEqualTo(64)
    }
  }
}
