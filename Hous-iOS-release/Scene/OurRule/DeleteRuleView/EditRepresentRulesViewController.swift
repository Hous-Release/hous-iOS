//
//  DeleteRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import UIKit
import RxSwift
import BottomSheetKit

final class EditRepresentRulesViewController: BaseViewController, LoadingPresentable {
  // MARK: - UI Components
  private let navigationBar = NavBarWithBackButtonView(
    title: "Rules 편집",
    rightButtonText: "저장").then {
      $0.setRightButtonTextColor(color: Colors.blue.color)
    }

  private let ruleEmptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 우리 집 Rules가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
  }

  private let rulesTableView = UITableView().then {
    $0.showsVerticalScrollIndicator = false
  }

  // MARK: - var & let
  private let viewModel: EditRepresentRulesViewModel

  private let rules: [HousRule]

  private let disposeBag = DisposeBag()

  private var selectedDict: [RuleState] = []

  private var saveButtonDidTap = PublishSubject<[Int]>()

  private var ruleDidTap = PublishSubject<Int>()

  // MARK: - Lifecycle
  init(rules: [HousRule], viewModel: EditRepresentRulesViewModel) {
    self.rules = rules
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    setTableView()
    bind()
  }

  // MARK: - Custom Methods
  private func setTableView() {
    rulesTableView.register(RulesTableViewCell.self, forCellReuseIdentifier: RulesTableViewCell.className)
  }

  private func setEmptyView() {
    rules.isEmpty ? (ruleEmptyViewLabel.isHidden = false) : (ruleEmptyViewLabel.isHidden = true)
  }

  private func setRemoveButtonStatus(to isEnabled: Bool) {
    if isEnabled {
      navigationBar.rightButton.isEnabled = true
      navigationBar.setRightButtonTextColor(color: Colors.blue.color)
    } else {
      navigationBar.rightButton.isEnabled = false
      navigationBar.setRightButtonTextColor(color: Colors.g4.color)
    }
  }

  private func configUI() {
    view.backgroundColor = Colors.white.color

    view.addSubViews([
      navigationBar,
      rulesTableView,
      ruleEmptyViewLabel
    ])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    rulesTableView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(28)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }

    ruleEmptyViewLabel.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(48)
      make.centerX.equalToSuperview()
    }

    setEmptyView()
    setRemoveButtonStatus(to: false)
  }

  private func bindTableView() {
    let observable = Observable.just(self.rules)

    rules.forEach { [weak self] rule in
      guard let self = self else { return }

      self.selectedDict.append(RuleState(id: rule.id, isSelected: false))
    }

    rulesTableView.rx.itemSelected
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        let ruleWithIDViewModel = self.rules[indexPath.row]
        let id = ruleWithIDViewModel.id

        guard let cell = self.rulesTableView.cellForRow(at: indexPath) as? RulesTableViewCell else { return }

        let state = self.selectedDict[indexPath.row].isSelected

        cell.selectButton.isSelected = !state
        self.selectedDict[indexPath.row].isSelected = cell.selectButton.isSelected

        self.ruleDidTap.onNext(id)

        var isExistSelected = false
        for rule in self.selectedDict where rule.isSelected {
          isExistSelected = true
          break
        }

        self.setRemoveButtonStatus(to: isExistSelected)

      })
      .disposed(by: disposeBag)

    observable
      .bind(to: rulesTableView.rx.items(
        cellIdentifier: RulesTableViewCell.className,
        cellType: RulesTableViewCell.self)
      ) { [weak self] row, _, cell in
        guard let self = self else { return }

        let ruleWithIDViewModel = self.rules[row]
        cell.setLayoutForDeleteRuleView()
        cell.setNormalRulesData(rule: ruleWithIDViewModel.name)

        cell.backgroundColor = Colors.white.color
        cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cell.selectionStyle = .none
        cell.selectButton.isSelected = self.selectedDict[row].isSelected

        cell.selectButton.rx.tap
          .asDriver(onErrorJustReturn: ())
          .drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            _ = ruleWithIDViewModel.id

            let state = self.selectedDict[row].isSelected
            cell.selectButton.isSelected = !state
            self.selectedDict[row].isSelected = cell.selectButton.isSelected
          })
          .disposed(by: cell.disposeBag)

      }
      .disposed(by: disposeBag)

    rulesTableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)

  }

  private func bind() {
    bindTableView()
    configButtonAction()

    let input = EditRepresentRulesViewModel.Input(
      saveButtonDidTap: saveButtonDidTap
        .do(onNext: { [weak self] _ in self?.showLoading() }),
      navBackButtonDidTapped: navigationBar.backButton.rx.tap.asObservable(),
      ruleDidTap: self.ruleDidTap
    )

    let output = viewModel.transform(input: input)

    output.moveToMainRuleView
      .drive(onNext: { [weak self] isEdited in
        guard let self = self else { return }
        if isEdited {
          popWithPopUp()
          return
        }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)

    output.savedComplete
      .do(onNext: { [weak self] _ in self?.hideLoading() })
      .drive(onNext: { [weak self] _ in
        guard let self else { return }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)

    output.representCountExceeded
      .do(onNext: { [weak self] _ in self?.hideLoading() })
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] isAppear in
        guard let self else { return }
        if isAppear {
          Toast.show(message: "대표 Rules는 3개까지 지정 가능해요!", controller: self)
        }
      })
      .disposed(by: disposeBag)

  }

  private func configButtonAction() {
    navigationBar.rightButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        let deletingRules = self.selectedDict.flatMap { ruleState -> [Int] in
          var deletingRules: [Int] = []
          if ruleState.isSelected { deletingRules.append(ruleState.id) }
          return deletingRules
        }
        self.saveButtonDidTap.onNext(deletingRules)
      })
      .disposed(by: disposeBag)
  }

  private func popWithPopUp() {
    let defaultPopUpModel = DefaultPopUpModel(
      cancelText: "계속 수정하기",
      actionText: "나가기",
      title: "수정사항이 저장되지 않았어요!",
      subtitle: "Rules 수정을 취소하려면 나가기 버튼을 눌러주세요."
    )

    let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: defaultPopUpModel)

    self.presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.navigationController?.popViewController(animated: true)
      case .cancel:
        break
      }
    }
  }

}

extension EditRepresentRulesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
}

struct RuleState {
  let id: Int
  var isSelected: Bool
}
