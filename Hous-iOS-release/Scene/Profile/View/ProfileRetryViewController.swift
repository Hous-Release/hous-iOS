//
//  ProfileRetryViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit

final class ProfileRetryViewController: UIViewController {
  
  override func viewDidLoad(){
    super.viewDidLoad()
    render()
  }
  
  private let backGroundView = UIView().then {
    $0.backgroundColor = .cyan
  }
  
  private func render() {
    view.addSubView(backGroundView)
    backGroundView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
  }
}
