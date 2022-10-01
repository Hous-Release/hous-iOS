//
//  SplashViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//


import Alamofire
import Lottie
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SplashViewController: UIViewController {

  private let lottieView: AnimationView = {
    let view = AnimationView(name: "splashlottie")
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    lottieView.play()
  }

  private func setupViews() {
    view.addSubView(lottieView)

    lottieView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalToSuperview()
    }
  }
}
