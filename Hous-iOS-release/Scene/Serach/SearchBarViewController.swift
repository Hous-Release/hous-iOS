//
//  SearchBarViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit

import RxSwift
import HousUIComponent

final class SearchBarViewController: UIViewController {

  // typealias Reactor =
  @frozen
  private enum Section: CaseIterable {
    case main
  }

  // MARK: - Properties
  // Todo : combine one way 포스팅 마저 읽고, 컴파인으로 뷰모델 연결

  private var items: [SearchModel] = []
  private var dataSource: UICollectionViewDiffableDataSource<Section, SearchModel>?

  private let disposeBag = DisposeBag()

  // MARK: - UI Components

  let searchBarView = UIView()
  let searchBar = HousSearchBar()
  lazy var filterView = FilterView()
  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.createLayout()
  )
  let floatingButton = PlusFloatingButton()

  init(_ type: SearchType) {
    super.init(nibName: nil, bundle: nil)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    configurationDataSource()
    // 필터뷰 버튼 히든처리 어케할지 생각하고, 필터 기능 구현
    // bind
    endEditWhenTouchedCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    searchBarEndEditing()
  }

  @objc
  func searchBarEndEditing() {
    searchBar.endEditing(true)
  }
}

private extension SearchBarViewController {

  func setDelegate() {
    collectionView.delegate = self
  }

  private func endEditWhenTouchedCollectionView() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(searchBarEndEditing))
    self.collectionView.backgroundView = UIView(frame: self.collectionView.bounds)
    collectionView.backgroundView?.addGestureRecognizer(gesture)
  }
}

private extension SearchBarViewController {

  func createLayout() -> UICollectionViewLayout {
    let config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  func configUI(_ type: SearchType) {

    var subViews: [UIView] = [
      searchBarView,
      collectionView,
      floatingButton
    ]
    if type == .todo { subViews.append(filterView) }
    self.view.addSubViews(subViews)
    searchBarView.addSubview(searchBar)

    searchBarView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    searchBar.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(24)
    }

    if type == .todo {
      filterView.snp.makeConstraints { make in
        make.top.equalTo(searchBarView.snp.bottom)
        make.leading.trailing.equalToSuperview()
        make.height.equalTo(SizeLiterals.FilterButton.height)
      }
    }

    collectionView.snp.makeConstraints { make in
      if type == .todo {
        make.top.equalTo(filterView.snp.bottom)
      } else {
        make.top.equalTo(searchBarView.snp.bottom).offset(8)
      }
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    floatingButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
      make.trailing.equalToSuperview().inset(36)
    }
  }

}

extension SearchBarViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    searchBarEndEditing()
  }
}

extension SearchBarViewController {
  func configurationDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<SearchBarViewCell, SearchModel> { (cell, _, item) in
      cell.configureCell(name: item.name)
    }

    dataSource = UICollectionViewDiffableDataSource<Section, SearchModel>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
        return collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: itemIdentifier)
      })
  }

  func filteredItems(with filter: String? = nil, limit: Int? = nil) -> [SearchModel] {
      let filtered = items.filter { $0.contains(filter) }
      if let limit {
          return Array(filtered.prefix(through: limit))
      }
      return filtered
  }

  func performQuery(with filter: String?) {
      let rules = filteredItems(with: filter)
          .sorted { $0.name < $1.name }
      var snapshot = NSDiffableDataSourceSnapshot<Section, SearchModel>()
      snapshot.appendSections([.main])
      snapshot.appendItems(rules)
      dataSource?.apply(snapshot, animatingDifferences: true)
  }
}
