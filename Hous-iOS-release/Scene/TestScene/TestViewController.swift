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


  private lazy var defaultButton: UIButton = {
    let button = UIButton()
    button.setTitle("default", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }()

  private lazy var copyCodeButton: UIButton = {
    let button = UIButton()
    button.setTitle("copyCode", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton2), for: .touchUpInside)
    return button
  }()
  private lazy var enterRoomButton: UIButton = {
    let button = UIButton()
    button.setTitle("enterRoom", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton3), for: .touchUpInside)
    return button
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("TestViewController is not implemented")
  }

  private func setupViews() {
    view.addSubview(defaultButton)
    view.addSubview(copyCodeButton)
    view.addSubview(enterRoomButton)
    view.addSubview(exceedButton)

    defaultButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
    copyCodeButton.snp.makeConstraints { make in
      make.top.equalTo(self.defaultButton.snp.bottom).offset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
    enterRoomButton.snp.makeConstraints { make in
      make.top.equalTo(self.copyCodeButton.snp.bottom).offset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
    exceedButton.snp.makeConstraints { make in
      make.top.equalTo(self.enterRoomButton.snp.bottom).offset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
  }
}

extension TestViewController {
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
  @objc
  private func didTapButton2() {

    let copyCodePopUpModel = ImagePopUpModel(image: "", actionText: "창여코드 복사하기",
                                                text:
"""
방 생성이 완료 되었습니다.
참여 코드를 복사해서
룸메이트에게 공유해보세요!
""")

    let popUpType = PopUpType.copyCode(copyPopUpModel: copyCodePopUpModel)

    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.dismiss(animated: true)
      case .cancel:
        self?.dismiss(animated: true)
      }
    }

  }
  @objc
  private func didTapButton3() {

    let enterRoomModel = ImagePopUpModel(image: "", actionText: "참여하기", text: "김호세")
    let popUpType = PopUpType.enterRoom(enterRoomModel: enterRoomModel)

    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.dismiss(animated: true)
      case .cancel:
        self?.dismiss(animated: true)
      }
    }

  }
  @objc
  private func didTapButton4() {
    let popModel = ImagePopUpModel(image: "", actionText: "참여하기", text: "김호세sdfdsfsdfsdfsdf\nsdfsdfsdfsd", titleText: "Rules 개수 초과")
    let popUpType = PopUpType.exceed(exceedModel: popModel)

    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.dismiss(animated: true)
      case .cancel:
        self?.dismiss(animated: true)
      }
    }

  }
}
