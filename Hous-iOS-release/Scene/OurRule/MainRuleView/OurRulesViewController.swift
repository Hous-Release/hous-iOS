//
//  OurRulesViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/26.
//

import UIKit
import BottomSheetKit
import RxCocoa
import RxDataSources
import RxSwift

class OurRulesViewController: BaseViewController, LoadingPresentable {

  private let navigationBar = NavBarWithBackButtonView(
    title: "우리 집 Rules",
    rightButtonImage: Images.frame1.image)

  private let rulesTableView = UITableView().then {
    $0.estimatedRowHeight = 150
    $0.rowHeight = UITableView.automaticDimension
    $0.showsVerticalScrollIndicator = false
  }

  private let disposeBag = DisposeBag()

  private let viewModel: RulesViewModel

  private lazy var configureCell:
  RxTableViewSectionedReloadDataSource<SectionOfRules>.ConfigureCell = {
    [unowned self] (_, _, indexPath, item) -> UITableViewCell in

    switch item {
    case .keyRules(let keyViewModel):
      return self.configKeyRulesCell(viewModel: keyViewModel, atIndex: indexPath)
    case .rule(let ruleViewModel):
      return self.configNormalRulesCell(viewModel: ruleViewModel, atIndex: indexPath)
    case .editRule(viewModel: let viewModel):
      return UITableViewCell()
    }

  }

  private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfRules>(configureCell: configureCell)

  private var rulesWithIds: [RuleWithIdViewModel] = []

  init(viewModel: RulesViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setTabBarIsHidden(isHidden: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    setTableView()
    bind()
  }

  private func setTableView() {
    rulesTableView.register(KeyRulesTableViewCell.self, forCellReuseIdentifier: KeyRulesTableViewCell.className)
    rulesTableView.register(RulesTableViewCell.self, forCellReuseIdentifier: RulesTableViewCell.className)

    rulesTableView.rowHeight = UITableView.automaticDimension
    rulesTableView.estimatedRowHeight = 150

    rulesTableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }

  private func configUI() {

    self.view.addSubViews([
      navigationBar,
      rulesTableView
    ])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    rulesTableView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  private func bind() {
    rx.rxViewWillAppear
      .asObservable()
      .do(onNext: { [weak self] _ in self?.showLoading() })
      .bind(to: viewModel.viewWillAppearSubject)
      .disposed(by: disposeBag)

    viewModel.rules
      .do(onNext: { [weak self] _ in self?.hideLoading() })
      .bind(to: rulesTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    navigationBar.backButton.rx.tap
      .asObservable()
      .bind(to: viewModel.backButtonDidTapped)
      .disposed(by: disposeBag)

    viewModel.popViewController
      .asObservable()
      .subscribe(onNext: {
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)

    navigationBar.rightButton.rx.tap
      .asObservable()
      .bind(to: viewModel.moreButtonDidTapped)
      .disposed(by: disposeBag)

    viewModel.presentBottomSheet
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }

        let bottomSheetType = BottomSheetType.defaultType

        let ruleList = self.rulesWithIds.map { ruleWithIdViewModel in
          ruleWithIdViewModel.name
        }

        self.presentBottomSheet(bottomSheetType) { actionType in

          var viewController = UIViewController()

          switch actionType {
          case .add:
            viewController = AddRuleViewController(rules: ruleList, viewModel: AddRuleViewModel())

          case .modify:
            viewController = EditRuleViewController(editViewRules: self.rulesWithIds, viewModel: EditRuleViewModel())
          case .delete:
            viewController = DeleteRuleViewController(rules: self.rulesWithIds, viewModel: DeleteRuleViewModel())
          case .cancel:
            return
          }

          viewController.view.backgroundColor = .white
          self.navigationController?.pushViewController(viewController, animated: true)
        }
      })
      .disposed(by: disposeBag)

    viewModel.ruleWithIds
      .subscribe(onNext: { [weak self] items in
        guard let self = self else { return }
        self.rulesWithIds = items
      })
      .disposed(by: disposeBag)

  }
}

extension OurRulesViewController {

  // Config Cells
  func configKeyRulesCell(
    viewModel: KeyRuleViewModel,
    atIndex: IndexPath
  ) -> UITableViewCell {

    guard let cell = self.rulesTableView.dequeueReusableCell(
      withIdentifier: KeyRulesTableViewCell.className,
      for: atIndex
    ) as? KeyRulesTableViewCell
    else {
      return UITableViewCell()
    }

    cell.setKeyRulesCell(ourRules: viewModel.names, ruleCount: viewModel.rulesTotalCount)

    cell.selectionStyle = .none
    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.rulesTableView.bounds.width)
    return cell
  }

  func configNormalRulesCell(
    viewModel: RuleViewModel,
    atIndex: IndexPath
  ) -> UITableViewCell {

    guard let cell = self.rulesTableView.dequeueReusableCell(
      withIdentifier: RulesTableViewCell.className,
      for: atIndex
    ) as? RulesTableViewCell
    else {
      return UITableViewCell()
    }

    cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    cell.setNormalRulesData(rule: viewModel.name)
    cell.selectionStyle = .none
    return cell
  }
}

extension OurRulesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 156
    }
    return 52
  }
}
