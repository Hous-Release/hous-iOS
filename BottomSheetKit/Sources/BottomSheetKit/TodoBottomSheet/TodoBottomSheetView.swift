//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import AssetKit
import SnapKit
import UIKit

internal final class TodoBottomSheetView: UIView {
  private typealias SpoqaHanSansNeo = Fonts.SpoqaHanSansNeo
  private typealias SECTION = TodoBottomSheetDataSource.Section
  private typealias ITEM = TodoBottomSheetDataSource.Item
  private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
  private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
  private typealias CellRegistration = UICollectionView.CellRegistration

  private struct Constants {
    static let verticalMargin: CGFloat = 16
    static let horizontalMargin: CGFloat = 24
    static let todoLabelTopMargin: CGFloat = 24
    static let buttonHeight: CGFloat = 38
    static let handleWidth: CGFloat = 80
    static let handleHeight: CGFloat = 4
  }

  private let rootView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.backgroundColor = .white
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    return view
  }()

  private let handleView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.g3.color
    view.layer.cornerCurve = .continuous
    view.layer.cornerRadius = 5
    return view
  }()

  private let todoLabel: UILabel = {
    let label = UILabel()
    label.text = "todoLabel"
    label.font = SpoqaHanSansNeo.medium.font(size: 16)
    label.textColor = Colors.black.color
    //label.textAlignment = .center
    return label
  }()

  private let daysLabel: UILabel = {
    let label = UILabel()
    label.text = "daysLabel"
    label.font = SpoqaHanSansNeo.medium.font(size: 13)
    label.textColor = Colors.g6.color
    label.numberOfLines = 1
    return label
  }()

  private var collectionView: UICollectionView! = nil

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = Constants.verticalMargin
    stackView.axis = .vertical
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(
      top: Constants.verticalMargin,
      left: Constants.horizontalMargin,
      bottom: Constants.verticalMargin,
      right: Constants.horizontalMargin
    )
    return stackView
  }()

  internal lazy var modifyButton: UIButton = {
    let button = UIButton()
    button.setTitle("수정하기", for: .normal)
    button.setTitleColor(Colors.black.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    button.titleLabel?.textAlignment = .center
    return button
  }()

  internal lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("삭제하기", for: .normal)
    button.setTitleColor(Colors.red.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    button.titleLabel?.textAlignment = .center
    return button
  }()

  private var dataSource: DataSource! = nil
  private var snapShot: SnapShot! = nil

  internal init(
    _ model: TodoModel
  ) {

    super.init(frame: .zero)
    configureCollectionView()
    configureDataSource()
    setLabel(model)
    setupViews()
    applyInitialSnapshot()
    applyHomiesSnapShot(model.homies.uniqued())

  }

  required init?(coder: NSCoder) {
    fatalError("DefaultBottomSheetView is Not Implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    updateCollectionViewHeight()
  }

  private func setLabel(_ model: TodoModel) {
    todoLabel.text = model.todoName
    daysLabel.text = model.days
    //daysLabel.text = processDaysModel(model.days)
  }

  private func processDaysModel(_ models: [Days]) -> String {
    guard !models.isEmpty else { return "" }

    var res = ""

    let removeDup = models.uniqued().sorted(by: <)

    for (i, day) in removeDup.enumerated() {
      if i == removeDup.endIndex - 1 {
        res += day.description
        break
      }

      res += (day.description + ", ")
    }

    return res
  }

  private func updateCollectionViewHeight() {

    collectionView.layoutIfNeeded()
    let height = collectionView.collectionViewLayout.collectionViewContentSize.height

    collectionView.snp.updateConstraints { make in
      make.height.greaterThanOrEqualTo(height)
    }

  }


  private func setupViews() {
    addSubview(rootView)
    rootView.addSubview(handleView)
    rootView.addSubview(todoLabel)
    rootView.addSubview(daysLabel)
    rootView.addSubview(collectionView)
    rootView.addSubview(stackView)

    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    handleView.snp.makeConstraints { make in
      make.width.equalTo(Constants.handleWidth)
      make.height.equalTo(Constants.handleHeight)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(Constants.verticalMargin)
    }

    todoLabel.snp.makeConstraints { make in
      make.top.equalTo(handleView.snp.bottom).offset(Constants.todoLabelTopMargin)
      make.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
    }

    daysLabel.snp.makeConstraints { make in
      make.top.equalTo(todoLabel.snp.bottom).offset(Constants.verticalMargin / 2)
      make.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(daysLabel.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.greaterThanOrEqualTo(1000)
      make.bottom.equalTo(stackView.snp.top).offset(0)
    }

    stackView.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom).offset(0)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(Constants.verticalMargin)
    }

    let l1 = makeG2LineView()
    let l2 = makeG2LineView()

    [modifyButton, deleteButton].forEach { button in
      button.snp.makeConstraints { make in
        make.height.equalTo(Constants.buttonHeight)
      }
    }

    [l1, l2].forEach { view in
      view.snp.makeConstraints { make in
        make.height.equalTo(1)
      }
    }
    stackView.addArrangedSubview(l1)
    stackView.addArrangedSubview(modifyButton)
    stackView.addArrangedSubview(l2)
    stackView.addArrangedSubview(deleteButton)
  }

  private func makeG2LineView() -> UIView {
    let view = UIView()
    view.backgroundColor = Colors.g2.color
    return view
  }
}

// MARK: - CollectionView Layout

extension TodoBottomSheetView {
  private func configureCollectionView() {
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: configureCollectionViewLayout()
    )

    collectionView.isPrefetchingEnabled = false
    collectionView.backgroundColor = Colors.white.color
    collectionView.isScrollEnabled = false
  }

  private func configureCollectionViewLayout() -> UICollectionViewLayout {
    let sectionProvider = { [weak self] (
      sectionIndex: Int,
      layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? in
      guard
        let sectionKind = SECTION(rawValue: sectionIndex),
        let self = self
      else {
        return nil
      }

      var section: NSCollectionLayoutSection

      switch sectionKind {
      case .homies:
        section = self.createSection()
      }
      return section

    }
    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }

  private func createSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(1),
      heightDimension: .estimated(1)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(4), bottom: nil)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(1)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )

    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(2), trailing: nil, bottom: .fixed(2))

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: Constants.verticalMargin,
      leading: Constants.horizontalMargin,
      bottom: Constants.verticalMargin,
      trailing: Constants.horizontalMargin
    )

    return section
  }
}
// MARK: - CollectionView DataSources

extension TodoBottomSheetView {

  private func applyHomiesSnapShot(_ homies: [HomieCellModel]) {
    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()
    let items = homies.map {
      ITEM.homie($0)
    }
    snapShot.append(items)
    dataSource.apply(snapShot, to: .homies)
  }

  private func applyInitialSnapshot() {
    let sections = SECTION.allCases
    snapShot = SnapShot()
    snapShot.appendSections(sections)
    dataSource.apply(snapShot, animatingDifferences: false)
  }

  private func configureDataSource() {
    let homieCellRegistration = CellRegistration<HomieCell, HomieCellModel> { (cell, indexPath, model) in
      cell.configure(model)
    }

    dataSource = DataSource(
      collectionView: collectionView) {( collectionView, indexPath, item) -> UICollectionViewCell? in

        switch item {

        case .homie(let homie):
          return collectionView.dequeueConfiguredReusableCell(
            using: homieCellRegistration,
            for: indexPath,
            item: homie
          )
        }
    }
  }
}
