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
  var mainView = TodoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
  }
}
