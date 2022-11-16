//
//  UpdateTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class UpdateTodoViewController: UIViewController, View {

  typealias Reactor = UpdateTodoReactor

  private typealias SECTION = UpdateTodoDataSource.Section
  private typealias ITEM = UpdateTodoDataSource.Item
  private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
  private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
  private typealias CellRegistration = UICollectionView.CellRegistration
  private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
  private typealias SectionSnapShot = NSDiffableDataSourceSectionSnapshot<ITEM>

  private struct Constants {
    static let verticalMargin: CGFloat = 16
    static let horizontalMargin: CGFloat = 24
    static let buttonHeight: CGFloat = 38
  }

  private var collectionView: UICollectionView!
  internal var disposeBag: DisposeBag = DisposeBag()
  private var dataSource: DataSource! = nil
  private var allSnapShot = SnapShot()
  private var assigneeSectionSnapShot = SectionSnapShot()
  private var individualSectionSnapShot = SectionSnapShot()

  init(
    _ reactor: Reactor,
    _ homies: [UpdateTodoHomieModel]
  ) {
    super.init(nibName: nil, bundle: nil)
    configureHierarchy()
    configureDataSource()
    applyInitialSnapshots()
    applySnapShot(homies)

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
  }

  func bindAction(_ reactor: Reactor) { }
  func bindState(_ reactor: Reactor) { }

}


extension UpdateTodoViewController {
  private func configureHierarchy() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = Colors.white.color
    collectionView.delegate = self
    view.addSubview(collectionView)
  }

  /// - Tag: CreateFullLayout
  private func createLayout() -> UICollectionViewLayout {

    let sectionProvider = { [weak self] (
      sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? in

      guard
        let self = self,
        let sectionKind = SECTION(rawValue: sectionIndex)
      else {
        return nil
      }

      let section: NSCollectionLayoutSection


      switch sectionKind {
      case .assignee:
        section = self.createSection()

      case .individual:

        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        section = NSCollectionLayoutSection.list(
          using: configuration,
          layoutEnvironment: layoutEnvironment
        )

        section.contentInsets = NSDirectionalEdgeInsets(
          top: 0,
          leading: 0,
          bottom: 0,
          trailing: 0
        )
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

    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: .fixed(4),
      top: nil,
      trailing: .fixed(4),
      bottom: nil
    )

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(1)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )

    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
      leading: nil,
      top: .fixed(2),
      trailing: nil,
      bottom: .fixed(2)
    )

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(
      top: Constants.verticalMargin / 2,
      leading: Constants.horizontalMargin,
      bottom: Constants.verticalMargin,
      trailing: Constants.horizontalMargin
    )

    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]



    return section
  }

  private func createHeaderRegistration() -> SupplementaryRegistration<TitleSupplementaryView> {

    return SupplementaryRegistration<TitleSupplementaryView>(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { supplementaryView, elementKind, indexPath in
      supplementaryView.label.text = "담당자"
    }
  }

  private func createAssigneeRegistration() -> CellRegistration<AssigneeCell, ITEM> {
    return CellRegistration<AssigneeCell, ITEM> { [weak self] (cell, indexPath, item) in
      guard
        let self = self,
        let item = item.homie
      else {
        return
      }
      cell.configure(item)
    }
  }

  private func createIndividualRegistration() -> CellRegistration<IndividualCell, ITEM> {
    return CellRegistration<IndividualCell, ITEM> { [weak self] (cell, indexPath, item) in
      guard
        let self = self,
        let item = item.homie
      else {
        return
      }
      cell.configure(item)

    }
  }
  private func createDayRegistration() -> CellRegistration<DayCell, ITEM> {
    return CellRegistration<DayCell, ITEM> { [weak self] (cell, indexPath, item) in
      guard
        let self = self,
        let item = item.homie
      else {
        return
      }
      cell.configure(item)
    }
  }

  private func configureDataSource() {

    let assigneeCellRegistration = createAssigneeRegistration()
    let individualRegistration = createIndividualRegistration()
    let dayRegistration = createDayRegistration()
    let headerRegistration = createHeaderRegistration()

    dataSource = DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in

      guard
        let section = SECTION(rawValue: indexPath.section)
      else {
        fatalError("Unknown section")
      }
      switch section {

      case .assignee:
        return collectionView.dequeueConfiguredReusableCell(
          using: assigneeCellRegistration,
          for: indexPath,
          item: item
        )

      case .individual:

        if item.hasChild {
          return collectionView.dequeueConfiguredReusableCell(
            using: individualRegistration,
            for: indexPath,
            item: item
          )
        }
        else {
          return collectionView.dequeueConfiguredReusableCell(
            using: dayRegistration,
            for: indexPath,
            item: item
          )
        }
      }
    }
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return self.collectionView.dequeueConfiguredReusableSupplementary(
        using: headerRegistration,
        for: index
      )
    }
  }

  private func applySnapShot(_ homies: [UpdateTodoHomieModel]) {
    applyAssigneeSnapShot(homies)
    applyIndividualSnapShot(homies)
  }

  private func applyAssigneeSnapShot(_ homies: [UpdateTodoHomieModel]) {
    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()

    let selectedHomies = homies.filter { !$0.selectedDay.isEmpty }

    let items = selectedHomies.map {
      ITEM.init(homie: $0, hasChild: false)
    }
    snapShot.append(items)
    self.assigneeSectionSnapShot = snapShot
    dataSource.apply(snapShot, to: .assignee, animatingDifferences: false)
  }

  private func applyIndividualSnapShot(_ homies: [UpdateTodoHomieModel]) {

    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()

    for homie in homies {
      let rootItem = ITEM(homie: homie, hasChild: true)
      snapShot.append([rootItem])

      let childItem = ITEM(homie: homie, hasChild: false)
      snapShot.append([childItem], to: rootItem)
      self.individualSectionSnapShot = snapShot
    }
    dataSource.apply(snapShot, to: .individual, animatingDifferences: false)
  }

  private func applyInitialSnapshots() {
    let sections = SECTION.allCases
    var snapshot = SnapShot()
    snapshot.appendSections(sections)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension UpdateTodoViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let item = self.dataSource.itemIdentifier(for: indexPath),
      let homie = item.homie
    else {
      return
    }

    if item.hasChild {
      let isExpanded = individualSectionSnapShot.isExpanded(item)

      isExpanded ?
      individualSectionSnapShot.collapse([item])
      :
      individualSectionSnapShot.expand([item])
      self.dataSource.apply(individualSectionSnapShot, to: .individual, animatingDifferences: true)

    }
  }
}
