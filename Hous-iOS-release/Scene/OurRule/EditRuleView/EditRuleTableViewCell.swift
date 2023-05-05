//
//  EditRuleTableViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/01.
//

import UIKit
import RxSwift

final class EditRuleTableViewCell: UITableViewCell {

  private let maxCount = 20

  private let dotView = UIView().then {
    $0.backgroundColor = Colors.g3.color
  }

  let todoLabelTextField = UITextField().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g7.color
    $0.textAlignment = .left
  }

  var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configUI()
    setNoti()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    dotView.layer.cornerRadius = dotView.layer.frame.height / 2
    dotView.layer.masksToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  private func setNoti() {
    NotificationCenter
      .default
      .addObserver(
        self,
        selector: #selector(textFieldDidChange),
        name: UITextField.textDidChangeNotification,
        object: nil
      )
  }

  private func configUI() {
    contentView.addSubViews([dotView, todoLabelTextField])

    dotView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(32)
      make.size.equalTo(8)
    }

    todoLabelTextField.snp.makeConstraints { make in
      make.centerY.equalTo(dotView)
      make.leading.equalTo(dotView.snp.trailing).offset(18)
      make.trailing.equalToSuperview().inset(24)
    }
  }

  func setTextFieldData(rule: String) {
    todoLabelTextField.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    todoLabelTextField.text = rule
  }
}

extension EditRuleTableViewCell {
  @objc func textFieldDidChange(noti: NSNotification) {
    if let textField = noti.object as? UITextField {
      switch textField {
      case todoLabelTextField:
        if let text = todoLabelTextField.text {
          if text.count > maxCount {
            let maxIndex = text.index(text.startIndex, offsetBy: maxCount)
            let newString = String(text[text.startIndex..<maxIndex])
            todoLabelTextField.text = newString
          }
        }
      default:
        return
      }
    }

  }
}
