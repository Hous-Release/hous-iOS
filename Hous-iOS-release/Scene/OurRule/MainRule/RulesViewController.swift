//
//  RulesViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/13.
//

import UIKit

import RxSwift
import BottomSheetKit

final class RulesViewController: BaseViewController, LoadingPresentable {

  @frozen
  private enum Section: CaseIterable {
    case main
  }

  // MARK: - UI Components

  private let navigationBar = NavBarWithBackButtonView(
    title: NavigationBar.Title.ruleMainTitle,
    rightButtonImage: Images.frame1.image)

  private let searchBar = HousSearchBar()

  private lazy var rulesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())

  private let floatingButton = PlusFloatingButton()

  // MARK: - Properties

  private var rules: [HousRule] = []

  private var dataSource: UICollectionViewDiffableDataSource<Section, HousRule>?

  private var nameFilter: String?

  private let disposeBag = DisposeBag()

  private let viewModel: RulesViewModel

  // MARK: - View Life Cycle

  init(viewModel: RulesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegate()
    setLayout()
    configureDataSource()
    bind()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    searchBarEndEditing()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
  }

  @objc
  func handleTap(recognizer: UITapGestureRecognizer) {
    searchBar.endEditing(true)
  }

  private func setDelegate() {
    rulesCollectionView.delegate = self
  }

  private func bind() {
    let viewWillAppear = rx.rxViewWillAppear
      .asObservable()
      .do(onNext: { [weak self] _ in self?.showLoading() })

        let backbuttonDidTap = navigationBar.backButton.rx.tap
        .asObservable()

        let moreButtonDidTap = navigationBar.rightButton.rx.tap
        .asObservable()

        let input = RulesViewModel.Input(
          viewWillAppear: viewWillAppear,
          backButtonDidTapped: backbuttonDidTap,
          moreButtonDidTapped: moreButtonDidTap)

        let output = viewModel.transform(input: input)

        output.rules
        .do(onNext: { [weak self] _ in self?.hideLoading() })
        .drive { rules in
          self.rules = rules
          self.performQuery(with: nil)
        }
        .disposed(by: disposeBag)

    output.popViewController
      .drive { _ in
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)

    output.presentBottomSheet
      .drive { _ in
        self.showBottomSheet()
      }
      .disposed(by: disposeBag)

    searchBar.rx.text
      .asDriver()
      .drive { str in
        self.performQuery(with: str)
      }
      .disposed(by: disposeBag)

  }
}

// MARK: - UI & Layout

private extension RulesViewController {
  func createLayout() -> UICollectionViewLayout {
    let config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
    return UICollectionViewCompositionalLayout.list(using: config)
  }

  func setLayout() {
    self.view.addSubViews([
      navigationBar,
      searchBar,
      rulesCollectionView,
      floatingButton
    ])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    searchBar.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(24)
    }

    rulesCollectionView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }

    floatingButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
      make.trailing.equalToSuperview().inset(36)
    }
  }

}

// MARK: - Delegate
 extension RulesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    searchBarEndEditing()
  }

 }

// MARK: - DataSource

extension RulesViewController {
  func configureDataSource() {
      let cellRegistration = UICollectionView.CellRegistration<RuleCollectionViewCell, HousRule> { (cell, _, item) in
        cell.configureCell(rule: item.name)
      }

      dataSource = UICollectionViewDiffableDataSource<Section, HousRule>(
        collectionView: rulesCollectionView,
        cellProvider: { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
          return collectionView
            .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
      })
  }

  func filteredRules(with filter: String? = nil, limit: Int? = nil) -> [HousRule] {
      let filtered = rules.filter { $0.contains(filter) }
      if let limit {
          return Array(filtered.prefix(through: limit))
      }
      return filtered
  }

  func performQuery(with filter: String?) {
      let rules = filteredRules(with: filter)
          .sorted { $0.name < $1.name }
      var snapshot = NSDiffableDataSourceSnapshot<Section, HousRule>()
      snapshot.appendSections([.main])
      snapshot.appendItems(rules)
      dataSource?.apply(snapshot, animatingDifferences: true)
  }
}

private extension RulesViewController {
  func showBottomSheet() {

    let bottomSheetType = BottomSheetType.defaultType

    let ruleList = self.rules.map { $0.name }

    self.presentBottomSheet(bottomSheetType) { actionType in

      var viewController = UIViewController()

      switch actionType {
      case .add:
        viewController = AddRuleViewController(rules: ruleList, viewModel: AddRuleViewModel())
      case .modify:
        viewController = EditRuleViewController(editViewRules: self.rules, viewModel: EditRuleViewModel())
      case .delete:
        viewController = DeleteRuleViewController(rules: self.rules, viewModel: DeleteRuleViewModel())
      case .cancel:
        return
      }

      viewController.view.backgroundColor = .white
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }

  @objc
  func searchBarEndEditing() {
    searchBar.endEditing(true)
  }

}
