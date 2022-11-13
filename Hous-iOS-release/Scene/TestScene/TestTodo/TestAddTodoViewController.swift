//
//  TestAddTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/13.
//

import UIKit


final class TestAddTodoViewController: UIViewController {

  private typealias SECTION = TestAddTodoDataSource.Section
  private typealias ITEM = TestAddTodoDataSource.Item
  private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
  private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
  private typealias CellRegistration = UICollectionView.CellRegistration

  private struct Constants {
    static let verticalMargin: CGFloat = 16
    static let horizontalMargin: CGFloat = 24
    static let buttonHeight: CGFloat = 38
  }

  private var collectionView: UICollectionView!
  private var dataSource: DataSource! = nil

  init(_ homies: [TestHomie]) {
    super.init(nibName: nil, bundle: nil)
    configureHierarchy()
    configureDataSource()
    applyInitialSnapshots()
    applySnapShot(homies)

  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

extension TestAddTodoViewController {
  private func configureHierarchy() {
      collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
      collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      collectionView.backgroundColor = .systemGroupedBackground
//      collectionView.delegate = self
      view.addSubview(collectionView)
  }

  /// - Tag: CreateFullLayout
  private func createLayout() -> UICollectionViewLayout {

    let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

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
        section = NSCollectionLayoutSection.list(
          using: .init(appearance: .plain),
          layoutEnvironment: layoutEnvironment
        )
        section.contentInsets = NSDirectionalEdgeInsets(
          top: 0,
          leading: 28,
          bottom: 0,
          trailing: 28
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

    item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(4), top: nil, trailing: .fixed(4), bottom: nil)

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
      top: 0,
      leading: Constants.horizontalMargin,
      bottom: Constants.verticalMargin,
      trailing: 0
    )

    return section
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
        print("item.hasChild ===" ,item.hasChild)

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
  }

  private func applySnapShot(_ homies: [TestHomie]) {
    applyAssigneeSnapShot(homies)
    applyIndividualSnapShot(homies)
  }

  private func applyAssigneeSnapShot(_ homies: [TestHomie]) {
    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()

    let selectedHomies = homies.filter { !$0.selectedDay.isEmpty }

    let items = selectedHomies.map {
      ITEM.init(homie: $0, hasChild: false)
    }
    snapShot.append(items)
    dataSource.apply(snapShot, to: .assignee, animatingDifferences: false)
  }

  private func applyIndividualSnapShot(_ homies: [TestHomie]) {

    var snapShot = NSDiffableDataSourceSectionSnapshot<ITEM>()

    for homie in homies {
      let rootItem = ITEM(homie: homie, hasChild: true)
      snapShot.append([rootItem])

      let childItem = ITEM(homie: homie, hasChild: false)
      snapShot.append([childItem], to: rootItem)
      snapShot.expand([rootItem])
    }

    print("SnapShot ===", snapShot)
    dataSource.apply(snapShot, to: .individual, animatingDifferences: false)
  }

  private func applyInitialSnapshots() {
    let sections = SECTION.allCases
    var snapshot = SnapShot()
    snapshot.appendSections(sections)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
