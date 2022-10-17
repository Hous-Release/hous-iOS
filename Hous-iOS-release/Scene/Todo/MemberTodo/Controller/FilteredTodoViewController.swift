//
//  FilteredTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/15.
//

import UIKit

import RxCocoa
import RxDataSources
import ReactorKit

//MARK: - Controller
final class FilteredTodoViewController: UIViewController {

  //var disposeBag = DisposeBag()
  var mainView = FilteredTodoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBar.delegate = self
  }
}

extension FilteredTodoViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTappedWithoutPopUp() {
    print("back")
  }

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
