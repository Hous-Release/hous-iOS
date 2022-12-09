//
//  DeleteRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import UIKit
import RxSwift
import BottomSheetKit

class DeleteRuleViewController: LoadingBaseViewController {
  //MARK: - UI Components
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "Rules 삭제")
    navBar.setRightButtonText(text: "삭제")
    return navBar
  }()
  
  private let ruleEmptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 우리 집 Rules가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
  }
  
  private let rulesTableView = UITableView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  //MARK: - var & let
  private let viewModel: DeleteRuleViewModel
  
  private let rules: [RuleWithIdViewModel]
  
  private let disposeBag = DisposeBag()
  
  private var selectedDict: [RuleState] = []
  
  private var deleteButtonDidTapped = PublishSubject<[Int]>()
  
  //MARK: - Lifecycle
  init(rules: [RuleWithIdViewModel], viewModel: DeleteRuleViewModel) {
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
  
  //MARK: - Custom Methods
  private func setTableView() {
    rulesTableView.register(RulesTableViewCell.self, forCellReuseIdentifier: RulesTableViewCell.className)
  }
  
  private func setEmptyView() {
    if rules.isEmpty {
      ruleEmptyViewLabel.isHidden = false
      navigationBar.rightButton.isEnabled = false
    } else {
      ruleEmptyViewLabel.isHidden = true
      navigationBar.rightButton.isEnabled = true
    }
  }
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
    view.addSubViews([
      navigationBar,
      rulesTableView,
      ruleEmptyViewLabel
    ])
    
    configLoadingLayout()
    
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
  }
  
  private func bindTableView() {
    let observable = Observable.just(self.rules)
    
    rules.forEach { [weak self] viewModel in
      guard let self = self else { return }
      self.selectedDict.append(RuleState(id: viewModel.id, isSelected: false))
    }
    
    rulesTableView.rx.itemSelected
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        let ruleWithIDViewModel = self.rules[indexPath.row]
        let ruleId = ruleWithIDViewModel.id

        guard let cell = self.rulesTableView.cellForRow(at: indexPath) as? RulesTableViewCell else { return }

        let state = self.selectedDict[indexPath.row].isSelected

        cell.selectButton.isSelected = !state
        self.selectedDict[indexPath.row].isSelected = cell.selectButton.isSelected
      })
      .disposed(by: disposeBag)
    
    observable
      .bind(to: rulesTableView.rx.items(cellIdentifier: RulesTableViewCell.className, cellType: RulesTableViewCell.self)) { [weak self] row, _, cell in
        guard let self = self else { return }
        
        let ruleWithIDViewModel = self.rules[row]
        cell.setLayoutForDeleteRuleView()
        cell.setNormalRulesData(rule: ruleWithIDViewModel.name)
        
        if row < 3 {
          cell.backgroundColor = Colors.blueL2.color
        } else {
          cell.backgroundColor = Colors.white.color
        }
        
        if row == 2 {
          cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.rulesTableView.bounds.width)
        } else {
          cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
        cell.selectionStyle = .none
        
        cell.selectButton.isSelected = self.selectedDict[row].isSelected
        
        cell.selectButton.rx.tap
          .asDriver(onErrorJustReturn: ())
          .drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            let ruleId = ruleWithIDViewModel.id
            
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
    
    let input = DeleteRuleViewModel.Input(
      deleteButtonDidTapped: deleteButtonDidTapped
        .do(onNext: { [weak self] _ in self?.showLoading() }),
      navBackButtonDidTapped: navigationBar.backButton.rx.tap.asObservable())
    
    let output = viewModel.transform(input: input)
    
    output.moveToMainRuleView
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    output.deletedCompleted
      .do(onNext: { [weak self] _ in self?.hideLoading() })
      .drive(onNext: {
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
  private func configButtonAction() {
    navigationBar.rightButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        
        let defaultPopUpModel = DefaultPopUpModel(
          cancelText: "취소하기",
          actionText: "삭제하기",
          title: "안녕, Rules...",
          subtitle: "Rules는 한 번 삭제하면 복구되지 않아요."
        )
        let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: defaultPopUpModel)

        self.presentPopUp(popUpType) { [weak self] actionType in
          guard let self = self else { return }
          switch actionType {
          case .action:
            let deletingRules = self.selectedDict.flatMap { ruleState -> [Int] in
              var deletingRules: [Int] = []
              if ruleState.isSelected { deletingRules.append(ruleState.id) }
              return deletingRules
            }
            self.deleteButtonDidTapped.onNext(deletingRules)
          case .cancel:
            break
          }
        }
      })
      .disposed(by: disposeBag)
  }
  
}


extension DeleteRuleViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
}


struct RuleState {
  let id: Int
  var isSelected: Bool
}
