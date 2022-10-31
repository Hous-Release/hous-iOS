//
//  OurRulesViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/26.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

class OurRulesViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "우리 집 Rules")
    navBar.setRightButtonImage(image: Images.frame1.image)
    return navBar
  }()
  
  private let rulesTableView = UITableView().then {
    $0.estimatedRowHeight = 150
    $0.rowHeight = UITableView.automaticDimension
  }
  
  private let disposeBag = DisposeBag()
  
  private let viewModel: RulesViewModel
  
  private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfRules>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
    
    switch item {
    case .keyRules(let keyViewModel):
      return self.configKeyRulesCell(viewModel: keyViewModel, atIndex: indexPath)
    case .rule(let ruleViewModel):
      return self.configNormalRulesCell(viewModel: ruleViewModel, atIndex: indexPath)
    }
    
  }
  
  private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfRules>(configureCell: configureCell)
  
  init(viewModel: RulesViewModel) {
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
    rulesTableView.register(KeyRulesTableViewCell.self, forCellReuseIdentifier: KeyRulesTableViewCell.className)
    rulesTableView.register(RulesTableViewCell.self, forCellReuseIdentifier: RulesTableViewCell.className)
    
    rulesTableView.rowHeight = UITableView.automaticDimension
    rulesTableView.estimatedRowHeight = 150
  }
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
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
    rx.RxViewWillAppear
      .debug("VC : ")
      .asObservable()
      .bind(to: viewModel.viewWillAppearSubject)
      .disposed(by: disposeBag)
    
    viewModel.rules
      .debug("rules : ")
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
      .subscribe(onNext: {
        print("✨ Bottom Sheet Presented ! ✨")
      })
      .disposed(by: disposeBag)
  }
}



extension OurRulesViewController {
  
  // Config Cells
  func configKeyRulesCell(viewModel: KeyRuleViewModel, atIndex: IndexPath) -> UITableViewCell {
    print("configKeyRules")
    guard let cell = self.rulesTableView.dequeueReusableCell(withIdentifier: KeyRulesTableViewCell.className, for: atIndex) as? KeyRulesTableViewCell else {
      return UITableViewCell()
    }
    
    cell.setKeyRulesCell(ourRules: viewModel.names)
    
    cell.selectionStyle = .none
    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.rulesTableView.bounds.width)
    return cell
  }
  
  func configNormalRulesCell(viewModel: RuleViewModel, atIndex: IndexPath) -> UITableViewCell {
    print("configNormalRules")
    guard let cell = self.rulesTableView.dequeueReusableCell(withIdentifier: RulesTableViewCell.className, for: atIndex) as? RulesTableViewCell else {
      return UITableViewCell()
    }
    
    cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    cell.setNormalRulesData(rule: viewModel.name)
    cell.selectionStyle = .none
    return cell
  }
}