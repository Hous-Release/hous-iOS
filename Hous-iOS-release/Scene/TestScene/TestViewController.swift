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

  private lazy var exceedButton: UIButton = {
    let button = UIButton()
    button.setTitle("excced", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton4), for: .touchUpInside)
    return button
  }()

  private lazy var duplicateButton: UIButton = {
    let button = UIButton()
    button.setTitle("duplicate", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton5), for: .touchUpInside)
    return button
  }()

  private lazy var defaultBottomSheetButton: UIButton = {
    let button = UIButton()
    button.setTitle("defaultBottomSheet", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton6), for: .touchUpInside)
    return button
  }()

  private lazy var todoBottomSheetButton: UIButton = {
    let button = UIButton()
    button.setTitle("todoBottomSheet", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapButton7), for: .touchUpInside)
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
    view.addSubview(duplicateButton)
    view.addSubview(defaultBottomSheetButton)
    view.addSubview(todoBottomSheetButton)

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
    duplicateButton.snp.makeConstraints { make in
      make.top.equalTo(self.exceedButton.snp.bottom).offset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
    defaultBottomSheetButton.snp.makeConstraints { make in
      make.top.equalTo(self.duplicateButton.snp.bottom).offset(10)
      make.height.equalTo(51)
      make.width.equalTo(300)
    }
    todoBottomSheetButton.snp.makeConstraints { make in
      make.top.equalTo(self.defaultBottomSheetButton.snp.bottom).offset(10)
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

    presentPopUp(popUpType) { actionType in
      switch actionType {
      case .action:
        break
      case .cancel:
        break
      }
    }

  }
  @objc
  private func didTapButton2() {

    let copyCodePopUpModel = ImagePopUpModel(
      image: .exceed,
      actionText: "창여코드 복사하기",
                                                text:
"""
방 생성이 완료 되었습니다.
참여 코드를 복사해서
룸메이트에게 공유해보세요!
""")

    let popUpType = PopUpType.copyCode(copyPopUpModel: copyCodePopUpModel)

    presentPopUp(popUpType) { actionType in
      switch actionType {
      case .action:
        break
      case .cancel:
        break
      }
    }

  }
  @objc
  private func didTapButton3() {

    let enterRoomModel = ImagePopUpModel(
      image: .test,
      actionText: "참여하기",
      text: "김호세"
    )
    let popUpType = PopUpType.enterRoom(enterRoomModel: enterRoomModel)

    presentPopUp(popUpType) { actionType in
      switch actionType {
      case .action:
        break
      case .cancel:
        break
      }
    }

  }
  @objc
  private func didTapButton4() {
    let popModel = ImagePopUpModel(image: .test, actionText: "참여하기", text: "김호세sdfdsfsdfsdfsdf\nsdfsdfsdfsd", titleText: "Rules 개수 초과")
    let popUpType = PopUpType.exceed(exceedModel: popModel)

    presentPopUp(popUpType) {  actionType in
      switch actionType {
      case .action:
        break
      case .cancel:
        break
      }
    }

  }
  @objc
  private func didTapButton5() {

    let popUpModel = DefaultPopUpModel(
      cancelText: "취소하기",
      actionText: "현재 기기에서 로그인하기",
      title: "다른 기기에서 로그인 중이에요!",
      subtitle: "다른 기기에서 강제 로그아웃 후 현재 기기에서\nHous-를 사용해볼까요?"
    )

    let popUpType = PopUpType.duplicate(popUpModel)

    presentPopUp(popUpType) { actionType in
      switch actionType {
      case .action:
        break
      case .cancel:
        break
      }
    }
  }
  @objc
  private func didTapButton6() {
    let bottomSheetType = BottomSheetType.defaultType

    presentBottomSheet(bottomSheetType) { actionType in

      switch actionType {
      case .add:
        print("ADD")
      case .modify:
        print("Modify")
      case .delete:
        print("Delete")
      case .cancel:
        print("Cancel")
      }
    }
  }

  @objc
  private func didTapButton7() {

    let homies = TestViewController.generateMock()
    let todoName = "유메니 보쿠라데 호오 핫테 키타루베키 히노 타메니 요루오 코에"
    //let days :[Days] = [.fri, .fri, .mon, .sat, .sun, .tue, .thu, .mon]
    let model = TodoModel(homies: homies, todoName: todoName, days: "")
    let bottomSheetType = BottomSheetType.todoType(model)

    presentBottomSheet(bottomSheetType) { actionType in

      switch actionType {
      case .add:
        break
      case .modify:
        print("Modify")
      case .delete:
        print("Delete")
      case .cancel:
        print("Cancel")
      }
    }
  }
}

extension TestViewController {
  static func generateMock() -> [HomieCellModel] {


    return [
      HomieCellModel(homieName: "민재쿤", homieColor: HomieFactory.makeHomie(type: .BLUE).color),
      HomieCellModel(homieName: "김민재", homieColor: HomieFactory.makeHomie(type: .BLUE).color),
      HomieCellModel(homieName: "민재김", homieColor: HomieFactory.makeHomie(type: .BLUE).color),
      HomieCellModel(homieName: "민재킴", homieColor: HomieFactory.makeHomie(type: .BLUE).color),
      HomieCellModel(homieName: "지현", homieColor: HomieFactory.makeHomie(type: .YELLOW).color),
      HomieCellModel(homieName: "지현킴", homieColor: HomieFactory.makeHomie(type: .YELLOW).color),
      HomieCellModel(homieName: "김지현", homieColor: HomieFactory.makeHomie(type: .YELLOW).color),
      HomieCellModel(homieName: "지현김", homieColor: HomieFactory.makeHomie(type: .YELLOW).color),
      HomieCellModel(homieName: "의진리", homieColor: HomieFactory.makeHomie(type: .GREEN).color),
      HomieCellModel(homieName: "이의진", homieColor: HomieFactory.makeHomie(type: .GREEN).color),
      HomieCellModel(homieName: "의진", homieColor: HomieFactory.makeHomie(type: .GREEN).color),
      HomieCellModel(homieName: "의진이", homieColor: HomieFactory.makeHomie(type: .GREEN).color),
      HomieCellModel(homieName: "김호세", homieColor: HomieFactory.makeHomie(type: .PURPLE).color),
      HomieCellModel(homieName: "김호세1", homieColor: HomieFactory.makeHomie(type: .PURPLE).color),
      HomieCellModel(homieName: "김호세2", homieColor: HomieFactory.makeHomie(type: .PURPLE).color),
      HomieCellModel(homieName: "김호세3", homieColor: HomieFactory.makeHomie(type: .PURPLE).color),
      HomieCellModel(homieName: "김호세3", homieColor: HomieFactory.makeHomie(type: .PURPLE).color),
      HomieCellModel(homieName: "김호세3", homieColor: HomieFactory.makeHomie(type: .PURPLE).color)

    ]


  }
}
