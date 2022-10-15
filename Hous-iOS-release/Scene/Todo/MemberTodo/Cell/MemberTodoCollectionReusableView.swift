//
//  MemberTodoCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/15.
//

import UIKit
import Then
import SnapKit

final class MemberTodoCollectionReusableView: UICollectionReusableView {

  var todoNum: String = "0"

  var todoNumLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 16)
    $0.textColor = Colors.g5.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MemberTodoCollectionReusableView {
  private func setUp() {
    let fullText = todoNumLabel.text ?? ""
    let attributedString = NSMutableAttributedString(string: fullText)
    let range = (fullText as NSString).range(of: todoNum)
    attributedString.addAttributes([
      .font: Fonts.Montserrat.semiBold.font(size: 20),
      .foregroundColor: Colors.blue.color], range: range)
    todoNumLabel.attributedText = attributedString
  }

  private func render() {
    addSubView(todoNumLabel)
    todoNumLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(28)
      make.centerY.equalToSuperview()
    }
  }
}
