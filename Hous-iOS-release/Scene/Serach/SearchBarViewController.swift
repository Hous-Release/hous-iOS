//
//  SearchBarViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit
import Combine
import HousUIComponent

final class SearchBarViewController: UIViewController {

  @frozen
  private enum Section: CaseIterable {
    case main
  }

  // MARK: - Properties

  var searchType: SearchType
  var viewModel: SearchBarViewModel
  private var subscriptions: Set<AnyCancellable> = []

  private var items: [SearchModel] = []
  private var dataSource: UICollectionViewDiffableDataSource<Section, SearchModel>?

  private var viewWillAppear = PassthroughSubject<SearchType, Never>()

  // MARK: - UI Components

  let searchBarView = UIView()
  let searchBar = HousSearchBar()
  lazy var filterView = FilterView()
  lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.createLayout()
  )
  let floatingButton = PlusFloatingButton()

  init(_ type: SearchType, viewModel: SearchBarViewModel) {
    self.searchType = type
    self.viewModel = viewModel
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
    bind()
    endEditWhenTouchedCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
    viewWillAppear.send(self.searchType)
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

extension SearchBarViewController {

  /// viewmodel binding
  func bind() {
    bindInput()
    bindOutput()
  }

  private func bindInput() {

    let searchBarPublisher = searchBar.publisher(for: .valueChanged)
      .map { $0 as? UITextField }
      .map { $0?.text }
      .eraseToAnyPublisher()

    let floatingButtonPublisher = floatingButton.publisher(for: .touchUpInside)
      .map { [unowned self] _ in self.searchType }
      .eraseToAnyPublisher()

    let input = SearchBarViewModel.Input(
      fetch: viewWillAppear.eraseToAnyPublisher(),
      // didTapFilterTodo: ,
      searchQuery: searchBarPublisher,
      // didTapCell: ,
      didTapFloatingBtn: floatingButtonPublisher
    )

    viewModel.transform(input: input)
  }

  private func bindOutput() {

    filterView.tapPublisher
      .sink { _ in
        // TODO: 필터 바텀시트 띄우기.
        print("filter button tapped!")
      }
      .store(in: &subscriptions)

    viewModel.$searchedList
      .compactMap { $0 }
      .sink { [weak self] list in
        guard let self = self else { return }
        self.applySnapshot(with: list)
        self.filterView.resultCnt = list.count
      }
      .store(in: &subscriptions)

    viewModel.$floatingBtnTapped
      .sink { [weak self] homies in
        guard let self else { return }

        let state = UpdateTodoReactor.State(
          todoHomies: homies ?? []
        )
        let provider = ServiceProvider()
        let reactor = UpdateTodoReactor(
          provider: provider,
          state: state
        )

        let viewController = UpdateTodoViewController(reactor)
        self.navigationController?.pushViewController(viewController, animated: true)
      }
      .store(in: &subscriptions)
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

  func applySnapshot(with list: [SearchModel]) {
      let sortedList = list.sorted { $0.name < $1.name }
      var snapshot = NSDiffableDataSourceSnapshot<Section, SearchModel>()
      snapshot.appendSections([.main])
      snapshot.appendItems(sortedList)
      dataSource?.apply(snapshot, animatingDifferences: true)
  }
}
