//
//  TodoFilterSheetView.swift
//
//
//  Created by 김민재 on 2/19/24.
//

import UIKit

import AssetKit
import HousUIComponent


final class TodoFilterSheetView: UIView {
  
  private typealias SECTION = TodoBottomSheetDataSource.Section
  private typealias ITEM = TodoBottomSheetDataSource.Item
  private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
  private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
  private typealias CellRegistration = UICollectionView.CellRegistration
  
  private struct Constants {
//    static let verticalMargin: CGFloat = 16
//    static let horizontalMargin: CGFloat = 24
    static let todoLabelTopMargin: CGFloat = 24
    static let buttonHeight: CGFloat = 38
    static let dayButtonSize: CGSize = CGSize(width: 40, height: 40)
    static let verticalMargin: CGFloat = 12
    static let horizontalMargin: CGFloat = 24
    static let distance: CGFloat = 8
  }
  
  private let rootView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.backgroundColor = .white
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "필터 설정"
    label.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    label.textColor = Colors.black.color
    return label
  }()
  
  private let dayTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "요일"
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textColor = Colors.g3.color
    return label
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.spacing = Constants.distance
    return stackView
  }()
  
  private let homieTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "호미"
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textColor = Colors.g3.color
    return label
  }()
  
  private let saveButton: UIButton = {
    let button = UIButton()
    button.setTitle("저장하기", for: .normal)
    button.setTitleColor(Colors.white.color, for: .normal)
    button.backgroundColor = Colors.blueL1.color
    return button
  }()
  
  private var collectionView: UICollectionView!
  private var dataSource: DataSource!
  private var snapShot: SnapShot!
  
  internal init(
    _ model: TodoModel
  ) {
    
    super.init(frame: .zero)
    configureCollectionView()
    configureDataSource()
    setHierarchy()
    setLayout()
    applyInitialSnapshot()
    applyHomiesSnapShot(model.homies.uniqued())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setHierarchy() {
    addSubview(rootView)
    rootView.addSubViews([
      titleLabel,
      dayTitleLabel,
      stackView,
      homieTitleLabel,
      collectionView,
      saveButton
    ])
    
    for day in Days.allCases {
      let button = makeDayButton(day)
      stackView.addArrangedSubview(button)

      button.snp.makeConstraints { make in
        make.height.equalTo(button.snp.width).multipliedBy(1)
        make.height.greaterThanOrEqualTo(Constants.dayButtonSize.height)
      }
    }
  }
  
  private func setLayout() {
    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(30)
      make.leading.equalToSuperview().inset(24)
    }
    
    dayTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.leading.equalTo(titleLabel)
    }
    
    stackView.snp.makeConstraints { make in
      make.top.equalTo(dayTitleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(24)
    }
    
    homieTitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(stackView)
      make.top.equalTo(stackView.snp.bottom).offset(24)
    }
    
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(homieTitleLabel.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview()
      make.height.greaterThanOrEqualTo(1000)
    }
    
    saveButton.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview().inset(39)
    }
  }
  
  private func makeDayButton(_ day: Days) -> UIButton {
    let button = UIButton()
    button.setTitle(day.description, for: .normal)
    button.layer.masksToBounds = true
    button.layer.cornerCurve = .circular
    button.layer.cornerRadius = Constants.dayButtonSize.height / 2
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)

    button.accessibilityIdentifier = day.description
    
    button.setBackgroundColor(Colors.g1.color, for: .normal)
    button.setTitleColor(Colors.g4.color, for: .normal)
    button.setBackgroundColor(Colors.blueL1.color, for: .selected)
    button.setTitleColor(Colors.blue.color, for: .selected)
    return button
  }
  
}


// MARK: - CollectionView Layout

extension TodoFilterSheetView {
  private func configureCollectionView() {
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: configureCollectionViewLayout()
    )
    
    collectionView.isPrefetchingEnabled = false
    collectionView.backgroundColor = Colors.white.color
    collectionView.isScrollEnabled = true
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
      heightDimension: .fractionalHeight(1)
    )
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: .fixed(8),
      top: nil,
      trailing: .fixed(8),
      bottom: nil
    )
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(1),
      heightDimension: .absolute(26)
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: nil,
      top: nil,
      trailing: nil,
      bottom: nil
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
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

extension TodoFilterSheetView {
  
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
