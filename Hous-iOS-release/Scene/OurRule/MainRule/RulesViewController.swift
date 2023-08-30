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
    title: StringLiterals.NavigationBar.Title.ruleMainTitle,
    rightButtonImage: Images.frame1.image)

  private let searchBar = HousSearchBar()

  private let housMenu = HousMenu().then {
    $0.addGuideButtonAction { _ in
      print("guide !")
    }

    $0.addEditButtonAction { _ in
      print("edit !")
    }

    $0.alpha = 0

  }

  private lazy var rulesCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.createLayout()).then {
    $0.backgroundView = UIView(frame: $0.bounds)
  }

  private let floatingButton = PlusFloatingButton()

  // MARK: - Properties

  private var rules: [HousRule] = []

  private var dataSource: UICollectionViewDiffableDataSource<Section, HousRule>?

  private var nameFilter: String?

  private let disposeBag = DisposeBag()

  private let viewModel: RulesViewModel

  private let ruleIdSubject = PublishSubject<Int>() // 규칙 조회 API

  private var selectedRuleId: Int?
  private let toDeleteRuleIdSubject = PublishSubject<Int>() // 규칙 삭제 API

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
    setLayout()
    configureDataSource()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
  }

  private func bind() {
    let viewWillAppear = rx.rxViewWillAppear
      .asObservable()
      .do(onNext: { [weak self] _ in self?.showLoading() })

        let backbuttonDidTap = navigationBar.backButton.rx.tap
        .asObservable()

        let moreButtonDidTap = navigationBar.rightButton.rx.tap
        .asObservable()

        let plusButtonDidTap = floatingButton.rx.tap.asObservable()

        let input = RulesViewModel.Input(
          viewWillAppear: viewWillAppear,
          backButtonDidTapped: backbuttonDidTap,
          moreButtonDidTapped: moreButtonDidTap,
          plusButtonDidTapped: plusButtonDidTap,
          ruleCellDidTapped: ruleIdSubject,
          deleteRuleDidTapped: toDeleteRuleIdSubject
        )

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
        let alpha: CGFloat = self.housMenu.alpha == 1 ? 0 : 1
        UIView.animate(withDuration: 0.3) {
          self.housMenu.alpha = alpha
        }
      }
      .disposed(by: disposeBag)

    output.presentAddViewController
      .drive { [weak self] _ in
        guard let self else { return }

        guard let rulesCount = dataSource?.snapshot(for: .main).items.count else { return }
        if rulesCount >= 30 {
          self.showExceedPopup()
          return
        }
        let viewController = AddEditRuleViewController(viewModel: AddEditViewModel(), type: .addRule)
        self.navigationController?.pushViewController(viewController, animated: true)
      }
      .disposed(by: disposeBag)

    output.ruleDetail
      .drive(onNext: { [weak self] dto in
        guard let self,
              let dto
        else { return }

        let photos = dto.images.map {
          return BottomSheetKit.RulePhoto(image: $0)
        }

        let cellModel = PhotoCellModel(ruleId: dto.id,
                                       title: dto.name,
                                       description: dto.description,
                                       lastmodifedDate: dto.updatedAt,
                                       photos: photos.isEmpty ? nil : photos)

        self.showBottomSheet(model: cellModel)
      })
      .disposed(by: disposeBag)

    output.deleteRuleComplete
      .drive(onNext: { [weak self] ruleId in
        guard let self else { return }
        guard let dataSource = self.dataSource else {
          return
        }

        var snapshot = dataSource.snapshot()

        let item = snapshot.itemIdentifiers(inSection: .main).filter { rule in
          return rule.id == ruleId
        }

        snapshot.deleteItems(item)

        DispatchQueue.main.async {
          self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        self.dismiss(animated: true)

      })
      .disposed(by: disposeBag)

    searchBar.rx.text
      .asDriver()
      .drive { str in
        self.performQuery(with: str)
      }
      .disposed(by: disposeBag)

    view.rx.tapGesture()
      .asDriver()
      .drive(onNext: { _ in
        self.searchBarEndEditing()
      })
      .disposed(by: disposeBag)

    rulesCollectionView.backgroundView?.rx.tapGesture()
      .asDriver()
      .drive(onNext: { _ in
        self.searchBarEndEditing()
      })
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
      floatingButton,
      housMenu
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

    housMenu.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.rightButton.snp.bottom).offset(7)
      make.trailing.equalTo(navigationBar.rightButton.snp.trailing).offset(6)
      make.width.equalTo(139)
    }
  }

}

// MARK: - DataSource

extension RulesViewController {
  func configureDataSource() {
      let cellRegistration = UICollectionView.CellRegistration<RuleCollectionViewCell, HousRule> { (cell, _, item) in
        cell.rx.tapGesture()
          .when(.recognized)
          .asDriver(onErrorJustReturn: UITapGestureRecognizer())
          .drive(onNext: { [weak self] _ in
            guard let self else { return }
            self.ruleIdSubject.onNext(item.id)
            self.selectedRuleId = item.id
          })
          .disposed(by: cell.disposeBag)
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

// MARK: - PopUp

private extension RulesViewController {
  func showBottomSheet(model: PhotoCellModel) {

    let bottomSheetType = BottomSheetType.ruleType(model)

    self.presentBottomSheet(bottomSheetType) { actionType in

      var viewController = UIViewController()

      switch actionType {
      case .cancel, .add:
        return
      case .modify:
        viewController = AddEditRuleViewController(
          viewModel: AddEditViewModel(),
          type: .updateRule,
          model: model)
      case .delete:
        guard let ruleId = model.ruleId else { return }
        self.dismiss(animated: false) {
          self.showDeletePopUp(ruleId: ruleId)
        }
        return
      }
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }

  func showExceedPopup() {
    let popModel = ImagePopUpModel(
      image: .exceed,
      actionText: "알겠어요!",
      text: "우리 집 Rules가 너무 많아요!\n필요하지 않은 Rule은 삭제하고\n다시 시도해주세요~",
      titleText: "Rules 개수 초과"
    )

    let popUpType = PopUpType.exceed(exceedModel: popModel)

    self.presentPopUp(popUpType) { actionType in
      switch actionType {
      case .action:
        break
      case .cancel:
        break
      }
    }
  }

  func showDeletePopUp(ruleId: Int) {
    let defaultPopUpModel = DefaultPopUpModel(
      cancelText: "취소하기",
      actionText: "삭제하기",
      title: "안녕, Rules...",
      subtitle: "Rules는 한 번 삭제하면 복구되지 않아요."
    )
    let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: defaultPopUpModel)

    presentPopUp(popUpType) { [weak self] actionType in
      guard let self = self else { return }
      switch actionType {
      case .action:
        guard let selectedRuleId else { return }
        self.toDeleteRuleIdSubject.onNext(selectedRuleId)
      case .cancel:
        break
      }
    }
  }

  func searchBarEndEditing() {
    searchBar.endEditing(true)
    housMenu.alpha = 0
  }

}
