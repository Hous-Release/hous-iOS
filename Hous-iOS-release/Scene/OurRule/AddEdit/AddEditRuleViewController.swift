//
//  AddEditRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/18.
//

import UIKit

import PhotosUI

@available(iOS 16.0, *)
final class AddEditRuleViewController: UIViewController {

  @frozen
  enum Section: Int, CaseIterable {
    case titleAndDescription = 0
    case photoInput
  }

  private let navigationBar = NavBarWithBackButtonView(
    title: StringLiterals.NavigationBar.Title.addEditTitle,
    rightButtonText: "추가")

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
    $0.isScrollEnabled = false
  }

  private var dataSource: UICollectionViewDiffableDataSource<Section, RulePhoto>?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setLayout()
    configureDataSource()
    collectionView.dataSource = dataSource
  }

  private func setLayout() {

    view.addSubViews([
      navigationBar,
      collectionView
    ])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

  }

}

@available(iOS 16.0, *)
extension AddEditRuleViewController {
  @available(iOS 16.0, *)
  func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in

      guard let section = Section(rawValue: sectionIndex) else { return nil }

      switch section {
      case .titleAndDescription:
        return self.createTitleSectionLayout(section: section)
      case .photoInput:
        return self.createPhotoInputSectionLayout(section: section)
      }
    }

    return layout
  }

  @available(iOS 16.0, *)
  func createTitleSectionLayout(section: Section) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)

    let section = NSCollectionLayoutSection(group: group)
    return section
  }

  func createPhotoInputSectionLayout(section: Section) -> NSCollectionLayoutSection {
    let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
    let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(24), heightDimension: .absolute(24))

    let badge = NSCollectionLayoutSupplementaryItem(
      layoutSize: badgeSize,
      elementKind: DeletePhotoCollectionReusableView.className,
      containerAnchor: badgeAnchor)

    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
    item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 12)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.45),
      heightDimension: .fractionalWidth(0.45))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

    section.orthogonalScrollingBehavior = .continuous

    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                         heightDimension: .estimated(50)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .topLeading)
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }
}

@available(iOS 16.0, *)
extension AddEditRuleViewController {
  func configureDataSource() {
    let titleCellRegistration = UICollectionView.CellRegistration<TitleDetailCollectionViewCell, Int> {_, _, _ in }
    let photoCellRegistration = UICollectionView.CellRegistration<PhotoCollectionViewCell, RulePhoto> { cell, _, item in
      cell.configPhotoCell(image: item.image)
    }

    let supplementaryRegistration = UICollectionView.SupplementaryRegistration
    <HeaderCollectionReusableView>(elementKind: UICollectionView.elementKindSectionHeader) {
      (supplementaryView, _, _) in
      supplementaryView.plusButtonClousre = {
        guard let dataSource = self.dataSource else { return }
        let currPhotoCount = dataSource.snapshot().itemIdentifiers(inSection: .photoInput).count
        var configuration = PHPickerConfiguration()

        configuration.selectionLimit = 5 - currPhotoCount
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
      }
    }

    let badgeRegistration = UICollectionView.SupplementaryRegistration
    <DeletePhotoCollectionReusableView>(elementKind: DeletePhotoCollectionReusableView.className) {
      (badgeView, _, indexPath) in

      badgeView.buttonTappedClosure = {
        guard let dataSource = self.dataSource else { return }
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else {
          return
        }
        var snapshot = dataSource.snapshot()

        print("snapshot remaining : ")
        print(snapshot.itemIdentifiers(inSection: .photoInput))
        print("=============indexPath=============")
        print(indexPath)

        snapshot.deleteItems([itemIdentifier])
        DispatchQueue.main.async {
          dataSource.apply(snapshot, animatingDifferences: true)
        }
      }

    }

    dataSource = UICollectionViewDiffableDataSource<Section, RulePhoto>(
      collectionView: collectionView,
      cellProvider: {
        collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in

        guard let section = Section(rawValue: indexPath.section) else { return nil}
        switch section {
        case .titleAndDescription:
          return collectionView
            .dequeueConfiguredReusableCell(using: titleCellRegistration, for: indexPath, item: 1)
        case .photoInput:

          return collectionView
            .dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: itemIdentifier)
        }
      })

    dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in

      if kind == UICollectionView.elementKindSectionHeader {
        return collectionView
          .dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
      } else if kind == DeletePhotoCollectionReusableView.className {

        return collectionView.dequeueConfiguredReusableSupplementary(using: badgeRegistration, for: indexPath)
      }
      return nil
    }

    var snapshot = NSDiffableDataSourceSnapshot<Section, RulePhoto>()

    // MARK: - 초기 세팅
    Section.allCases.forEach {
      snapshot.appendSections([$0])
      if $0 == .photoInput {
        return
      }
      snapshot.appendItems([RulePhoto(image: UIImage())])

    }

    dataSource?.apply(snapshot, animatingDifferences: true)
  }
}

@available(iOS 16.0, *)
extension AddEditRuleViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

    results.forEach { result in
      result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
        guard let image = reading as? UIImage,
              error == nil else {
          print("ddd")
          return
        }
        guard let dataSource = self.dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([RulePhoto(image: image)], toSection: .photoInput)

        DispatchQueue.main.async {
          dataSource.apply(snapshot, animatingDifferences: true)
        }
      }
    }

    picker.dismiss(animated: true)

  }

}
