//
//  EnterRoomView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/25.
//

import UIKit

import SnapKit
import Then

class EnterRoomView: UIView {

  // 3. 공통버튼 만든거 불러와서 뷰 짜기
  // 4. 탭제스쳐 rx랑 연결해서 뷰 전환 구현

  let guideTitleLabel = UILabel().then {
    $0.text = "이제 하우스를 입장해볼까요?"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textColor = Colors.black.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {

  }
}
