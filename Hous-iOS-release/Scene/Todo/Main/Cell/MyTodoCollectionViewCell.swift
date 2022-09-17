//
//  MyTodoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/11.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MyTodoCollectionViewCell: UICollectionViewCell, View {

  var disposeBag = DisposeBag()

  var isChecked: Bool = false {
    didSet {
      if isChecked {
        checkButton.isSelected = true
        myTodoLabel.textColor = Colors.g5.color
      } else {
        checkButton.isSelected = false
        myTodoLabel.textColor = Colors.black.color
      }
    }
  }

  var checkButton = UIButton().then {
    $0.setImage(Images.icNoMy.image, for: .normal)
    $0.setImage(Images.icDoneMy.image, for: .selected)
  }

  private var myTodoLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
    $0.text = "블라블라블라"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    reactor = MyTodoCollectionViewCellReactor()
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(reactor: MyTodoCollectionViewCellReactor) {
    checkButton.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { [weak self] in Reactor.Action.check((self?.checkButton.isSelected)!) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isChecked }
      .subscribe { [weak self] status in
        self?.isChecked = status
      }
      .disposed(by: disposeBag)
  }
}

extension MyTodoCollectionViewCell {

  private func render() {

    [checkButton, myTodoLabel].forEach { addSubview($0) }

    checkButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(26)
      make.centerY.equalToSuperview()
      make.size.equalTo(20)
    }

    myTodoLabel.snp.makeConstraints { make in
      make.leading.equalTo(checkButton.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
    }
  }

  func setCell(_ isChecked: Bool, _ todoName: String) {
    self.isChecked = isChecked
    myTodoLabel.text = todoName
  }
}
