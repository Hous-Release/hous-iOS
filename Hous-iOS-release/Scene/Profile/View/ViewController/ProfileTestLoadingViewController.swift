//
//  ProfileSettingViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import Lottie
import AssetKit

final class ProfileTestLoadingViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  let viewModel = ProfileTestViewModel()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private let loadingLottie = AnimationView.init(name: "test_lottie").then {
    $0.loopMode = .loop
    $0.play()
  }
  
  private let loadingLabel = UILabel().then {
    $0.text = "결과 나오는 중"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
  }
  
  private let pleaseWaitLabel = UILabel().then {
    $0.text = "조금만 기다려주세요!"
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 20)
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    render()
  }
  
  private func render() {
    view.addSubViews([loadingLottie, loadingLabel, pleaseWaitLabel])
    
    loadingLottie.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.height.equalTo(219)
      make.top.equalToSuperview().offset(228)
    }
    
    loadingLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(loadingLottie.snp.bottom).offset(47)
    }
    
    pleaseWaitLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(loadingLabel.snp.bottom)
    }
    
  }
}

