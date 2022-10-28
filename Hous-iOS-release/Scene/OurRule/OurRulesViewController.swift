//
//  OurRulesViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/26.
//

import UIKit
import RxCocoa
import RxSwift

class OurRulesViewController: UIViewController {
  
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "우리 집 Rules")
    navBar.setRightButtonImage(image: Images.frame1.image)
    return navBar
  }()
  
  private let rulesTableView = UITableView()
  
  let disposeBag = DisposeBag()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()
    setTableView()
    bind(RulesViewModel(dummy: ["규칙추가1", "규칙추가2", "규칙추가3", "규칙 ㅁㄴ아ㅜ"]))
  }
  
  private func setTableView() {
    rulesTableView.register(KeyRulesTableViewCell.self, forCellReuseIdentifier: KeyRulesTableViewCell.className)
    
    rulesTableView.register(RulesTableViewCell.self, forCellReuseIdentifier: RulesTableViewCell.className)
    
    rulesTableView.rowHeight = UITableView.automaticDimension
    rulesTableView.estimatedRowHeight = 150
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
  
  private func bind(_ viewModel: RulesViewModel) {
    viewModel.getCellData()
      .bind(to: rulesTableView.rx.items) { (tableView, row, item) -> UITableViewCell in
        if row == 0 {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: KeyRulesTableViewCell.className, for: IndexPath.init(row: row, section: 0)) as? KeyRulesTableViewCell else {
            return UITableViewCell()
          }
          cell.setKeyRulesCell(ourRules: [item])
          cell.selectionStyle = .none
          cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
          return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RulesTableViewCell.className, for: IndexPath.init(row: row, section: 0)) as? RulesTableViewCell else {
          return UITableViewCell()
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cell.setNormalRulesData(rule: item)
        cell.selectionStyle = .none
        return cell
        
      }
      .disposed(by: disposeBag)
  }
}
