//
//  ProfileSettingViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit

final class ProfileSettingViewController: UIViewController {
  
  override func viewDidLoad(){
    super.viewDidLoad()
    render()
  }
  
  private let backGroundView = UIView().then {
    $0.backgroundColor = .orange
  }
  
  private func render() {
    view.addSubView(backGroundView)
    backGroundView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
  }
}
