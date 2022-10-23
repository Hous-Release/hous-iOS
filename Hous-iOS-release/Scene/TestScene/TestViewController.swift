//
//  TestViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/10/22.
//

import BottomSheetKit
import Foundation
import SnapKit
import UIKit

final class TestViewController: UIViewController {


  private lazy var presentButton: UIButton = {
    let button = UIButton()
    button.setTitle("present", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("TestViewController is not implemented")
  }

  @objc
  private func didTapButton() {


    let twoButtonPopupModel = TwoButtonPopUpModel(
      cancelText: "취소하기",
      actionText: "액션하기",
      title: "ㅇㄴㄹㄴㅇㄹㄴㅇㄹㅇㄴㄹㄴㅇㄹ\nasdsdasdㅇ",
      subtitle: "어쩌고저ㅓ겆고ㅓ"
    )
    let popUpType = PopUpType.twoButton(twoButtonPopUpModel: twoButtonPopupModel)

    presentPopUp(popUpType) { actionType in
      switch actionType {
      case .action:
        print("action입니다")
      case .cancel:
        print("Cancel입니다")
      }
    }

  }

  private func setupViews() {
    view.addSubview(presentButton)

    presentButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
  }
}
