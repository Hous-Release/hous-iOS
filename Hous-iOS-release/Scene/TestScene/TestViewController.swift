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
    button.setTitle("default", for: .normal)
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


    let defaultPopUpModel = DefaultPopUpModel(
      cancelText: "취소하기",
      actionText: "액션하기",
      title: "ㅇㄴㄹㄴㅇㄹㄴㅇㄹㅇㄴㄹㄴㅇㄹ\nasdsdasdㅇsdfdsfdsfdsfsdfsdfsdfsdfdsfsdf",
      subtitle: "어쩌고저ㅓ겆고ㅓsdfsdfsdfsdfsdfsdfsdfdsdsfdddfhjjhjh"
    )
    let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: defaultPopUpModel)

    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.dismiss(animated: true)
      case .cancel:
        self?.dismiss(animated: true)
      }
    }

  }

  private func setupViews() {
    view.addSubview(presentButton)

    presentButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
  }
}
