//
//  EditRuleViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Network

class EditRuleViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "Rules 수정")
    navBar.setRightButtonText(text: "저장")
    return navBar
  }()
  
  private let rulesTableView = UITableView().then {
    $0.allowsSelectionDuringEditing = true
    $0.isEditing = true
  }
  
  private let ruleEmptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 우리 집 Rules가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
  }
  
  private let disposeBag = DisposeBag()
  
  private var editViewRules: [SectionOfRules]
  
  private let viewModel: EditRuleViewModel
  
  private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfRules>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
    
    switch item {
    case .editRule(let viewModel):
      return self.configEditRulesCell(viewModel: viewModel, atIndex: indexPath)
    default:
      return UITableViewCell()
    }
  }
  
  private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfRules>(configureCell: configureCell)
  
  
  init(editViewRules: [SectionOfRules], viewModel: EditRuleViewModel) {
    self.editViewRules = editViewRules
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTableView()
    configUI()
    bind()
  }
  
  private func setTableView() {
    rulesTableView.register(EditRuleTableViewCell.self, forCellReuseIdentifier: EditRuleTableViewCell.className)
    rulesTableView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func configUI() {
    navigationBar.updateRightButtonSnapKit()
    
    self.view.addSubViews([
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
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    ruleEmptyViewLabel.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(48)
      make.centerX.equalToSuperview()
    }
  }
  
  private func bind() {
    let observable = Observable.just(self.editViewRules)
    
    observable
      .bind(to: rulesTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    rulesTableView.rx.itemMoved
      .map { $0 }
      .subscribe { event in
        self.editViewRules[0].items.swapAt(event.sourceIndex.row, event.destinationIndex.row)
      }
      .disposed(by: disposeBag)
    
    let editViewList = editViewRules.flatMap { model in
      var ruleWithIds: [RuleWithIdViewModel] = []
      
      _ = model.items.map { item in
        switch item {
        case .editRule(let viewModel):
          ruleWithIds.append(RuleWithIdViewModel(id: viewModel.id, name: viewModel.name))
        default:
          break
        }
      }
      
      return ruleWithIds
    }
    
    let ruleWithIdsObservable = Observable.just(editViewList)
    
    let input = EditRuleViewModel.Input(
      backButtonDidTap: navigationBar.backButton.rx.tap.asObservable(),
      saveButtonDidTap: ruleWithIdsObservable
    )
  }
}

extension EditRuleViewController {
  func configEditRulesCell(viewModel: RuleWithIdViewModel, atIndex: IndexPath) -> UITableViewCell {
    
    guard let cell = self.rulesTableView.dequeueReusableCell(withIdentifier: EditRuleTableViewCell.className, for: atIndex) as? EditRuleTableViewCell else {
      return UITableViewCell()
    }
    cell.setTextFieldData(rule: viewModel.name)
    
    cell.todoLabelTextField.rx.text
      .distinctUntilChanged()
      .debug("text✨")
      .asObservable()
      .subscribe(onNext: { [weak self] str in
        guard let self = self else { return }
        let changedName = str.map { $0 }
        
        let ruleWithIdViewModel = RuleWithIdViewModel(id: viewModel.id, name: changedName ?? "WHyNIL?")
        
        self.editViewRules[0].items[atIndex.row] = TableViewItem.editRule(viewModel: ruleWithIdViewModel)
      })
      .disposed(by: cell.disposeBag)
    
    if atIndex.row <= 2 {
      cell.backgroundColor = Colors.blueL2.color
    }
    
    cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    cell.selectionStyle = .none
    return cell
  }
}

// Hiding Delete Button in TableView edit mode
extension EditRuleViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
  
  func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
      return false
  }
}
