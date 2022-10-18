//
//  TodoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/09.
//

import UIKit

import SnapKit
import Then

final class TodoView: UIView {

  enum Size {
    static let itemSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
    static let headerSize = CGSize(width: UIScreen.main.bounds.width, height: 48)
    static let footerSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
  }

  private let navigationBarView = UIView()

  private let dateStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
  }

  var dateLabel = UILabel().then {
    $0.text = ""
    $0.font = Fonts.Montserrat.bold.font(size: 24)
    $0.textColor = Colors.blueL1.color
  }

  var dayOfWeekLabel = UILabel().then {
    $0.text = ""
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

  var progressBarView = ProgressBarView()

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical
      layout.estimatedItemSize = Size.itemSize
      layout.headerReferenceSize = Size.headerSize
      layout.footerReferenceSize = Size.footerSize
      $0.collectionViewLayout = layout
      $0.showsVerticalScrollIndicator = false
      $0.register(cell: MyTodoCollectionViewCell.self)
      $0.register(cell: OurTodoCollectionViewCell.self)
      $0.register(TodoHeaderCollectionReusableView.self,
                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                  withReuseIdentifier: TodoHeaderCollectionReusableView.className)
      $0.register(TodoFooterCollectionReusableView.self,
                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                  withReuseIdentifier: TodoFooterCollectionReusableView.className)
    }

  override init(frame: CGRect) {
    super.init(frame: frame)

    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    self.backgroundColor = .white
    [navigationBarView, progressBarView, todoCollectionView].forEach { addSubview($0) }
    [dateStackView, viewAllButton].forEach { navigationBarView.addSubview($0) }
    dateStackView.addArrangedSubviews(dateLabel, dayOfWeekLabel)

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
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

    progressBarView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(92)
    }

    todoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(progressBarView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(80)
    }
  }

}
