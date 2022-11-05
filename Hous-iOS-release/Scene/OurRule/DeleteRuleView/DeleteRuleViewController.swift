//
//  DeleteRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import UIKit
import RxSwift

class DeleteRuleViewController: UIViewController {
  //MARK: - UI Components
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "Rules 삭제")
    navBar.setRightButtonText(text: "삭제")
    return navBar
  }()
  
  private let rulesTableView = UITableView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  //MARK: - var & let
  private let viewModel: DeleteRuleViewModel
  
  private let rules: [RuleWithIdViewModel]
  
  private let disposeBag = DisposeBag()
  
  private var selectedDict: [Int: Bool] = [:]
  
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
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
    view.addSubViews([
      navigationBar,
      rulesTableView
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
  }
  
  private func bindTableView() {
    let observable = Observable.just(self.rules)
    
    rules.forEach { [weak self] viewModel in
      guard let self = self else { return }
      self.selectedDict[viewModel.id] = false
    }
    
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
        
        cell.selectButton.rx.tap
          .asDriver(onErrorJustReturn: ())
          .drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            let ruleId = ruleWithIDViewModel.id
            
            cell.selectButton.isSelected.toggle()
            self.selectedDict[ruleId] = cell.selectButton.isSelected
          })
          .disposed(by: cell.disposeBag)
        
      }
      .disposed(by: disposeBag)
  }
  
  private func bind() {
    bindTableView()
    configButtonAction()
    
    let input = DeleteRuleViewModel.Input(
      deleteButtonDidTapped: deleteButtonDidTapped,
      navBackButtonDidTapped: navigationBar.backButton.rx.tap.asObservable())
    
    let output = viewModel.transform(input: input)
    
    output.moveToMainRuleView
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    output.deletedCompleted
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
        let deletingRules = self.selectedDict.flatMap { (key, flag) -> [Int] in
          var deletingRules: [Int] = []
          if flag { deletingRules.append(key) }
          return deletingRules
        }
        self.deleteButtonDidTapped.onNext(deletingRules)
      })
      .disposed(by: disposeBag)
  }
  
}
