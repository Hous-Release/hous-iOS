//
//  SplashViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//

import UIKit

import RxCocoa
import Alamofire
import RxSwift



struct TestViewModel: ViewModelType {
  struct Input {
    let viewWillAppear: Observable<Void>
  }
  struct Output {
    let result: Observable<[Int]>
  }

  func transform(input: Input) -> Output {

    let result = input.viewWillAppear
      .map { _ in [3,4,5,6,7,8] }
      .asObservable()


    return Output(result: result)
  }
}




final class SplashViewController: UIViewController {
  private let viewModel = TestViewModel()

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }

  private func bind() {
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map {_ in () }
      .asObservable()

    let input = TestViewModel.Input(viewWillAppear: viewWillAppear)

    let output = viewModel.transform(input: input)


    output.result
      .subscribe(onNext: { intArray in
        print(intArray)
      })
      .disposed(by: disposeBag)

  }
}
