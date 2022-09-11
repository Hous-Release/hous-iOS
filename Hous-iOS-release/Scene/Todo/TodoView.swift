//
//  TodoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/09.
//

import UIKit

import SnapKit
import Then

class TodoView: UIView {

  enum Size {

  }

  private let navigationBarView = UIView()

  private let dateStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
  }

  let dateLabel = UILabel().then {
    $0.text = "08.18"
    $0.font = Fonts.Montserrat.bold.font(size: 24)
    $0.textColor = Colors.blueL1.color
  }

  let dayOfWeekLabel = UILabel().then {
    $0.text = "Thursday"
    $0.font = Fonts.Montserrat.bold.font(size: 24)
    $0.textColor = Colors.blue.color
  }

  let viewAllButton = UIButton().then {
    var config = UIButton.Configuration.filled()
    config.baseForegroundColor = Colors.blue.color
    config.baseBackgroundColor = Colors.blueL2.color
    config.titleAlignment = .center
    let titleAttributes: [NSAttributedString.Key: Any] = [
      .font: Fonts.Montserrat.semiBold.font(size: 14),
    ]
    let subtitleAttributes: [NSAttributedString.Key: Any] = [
      .font: Fonts.SpoqaHanSansNeo.bold.font(size: 12),
    ]
    config.attributedTitle = AttributedString("to-do", attributes: AttributeContainer(titleAttributes))
    config.attributedSubtitle = AttributedString("전체보기", attributes: AttributeContainer(subtitleAttributes))
    $0.configuration = config
  }

  private let progressView = UIView()

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      //layout.itemSize = Size.categoryCollectionItemSize
      //layout.sectionInset = Size.categoryCollectionEdgeInsets
      layout.scrollDirection = .horizontal
      $0.collectionViewLayout = layout
      $0.showsHorizontalScrollIndicator = false
      $0.backgroundColor = .white
      //$0.register(cell: CategoryCollectionViewCell.self)
    }

  override init(frame: CGRect) {
    super.init(frame: frame)

    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {

    [navigationBarView, progressView, todoCollectionView].forEach { addSubview($0) }
    [dateStackView, viewAllButton].forEach { navigationBarView.addSubview($0) }
    dateStackView.addArrangedSubviews(dateLabel, dayOfWeekLabel)

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(94)
    }

    dateStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(32)
      make.leading.equalToSuperview().offset(24)
      make.bottom.equalToSuperview()
    }

    viewAllButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview()
    }

    progressView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(92)
    }

    todoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(progressView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

}
