//
//  AddRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import UIKit
import RxSwift

class AddRuleViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "새로운 Rules 추가")
    navBar.setRightButtonText(text: "저장")
    return navBar
  }()
  
  private let ruleTextField = UITextField().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.placeholder = "Rules 입력"
  }
  
  private let blueLine = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }
  
  private let plusButton = UIButton().then {
    $0.setImage(Images.icAdd.image, for: .normal)
  }
  
  private let ruleTableView = UITableView()
  
  private let viewModel: AddRuleViewModel
  
  private let disposeBag = DisposeBag()
  
  private let rules: [RuleWithIdViewModel]
  
  init(rules: [RuleWithIdViewModel], viewModel: AddRuleViewModel) {
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
  
  private func setTableView() {
    ruleTableView.register(EditRuleTableViewCell.self, forCellReuseIdentifier: EditRuleTableViewCell.className)
  }
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
    view.addSubViews([
      navigationBar,
      ruleTextField,
      blueLine,
      plusButton,
      ruleTableView
    ])
    
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }
    
    plusButton.snp.makeConstraints { make in
      make.centerY.equalTo(ruleTextField)
      make.centerX.equalTo(navigationBar.rightButton)
    }
    
    ruleTextField.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(32)
      make.leading.equalToSuperview().offset(25)
      make.trailing.equalTo(plusButton.snp.leading)
    }
    
    blueLine.snp.makeConstraints { make in
      make.top.equalTo(ruleTextField.snp.bottom).offset(7)
      make.height.equalTo(2)
      make.leading.trailing.equalToSuperview().inset(24)
    }
    
    ruleTableView.snp.makeConstraints { make in
      make.top.equalTo(blueLine.snp.bottom).offset(19)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.snp.bottom).inset(83)
    }
    
  }
  
  private func bind() {
    let observable = Observable.just(self.rules)
    
    observable
      .bind(to: ruleTableView.rx.items(cellIdentifier: EditRuleTableViewCell.className, cellType: EditRuleTableViewCell.self)) { row, viewModel, cell in
        cell.setTextFieldData(rule: viewModel.name)
      }
      .disposed(by: disposeBag)
      
  }
  
}
