//
//  ProfileTestCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/12.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol TestCollectionViewCellDelegate: AnyObject {
  func optionButtonDidTapped(_ sender: UIButton, _ tag: Int)
}

class TestCollectionViewCell: UICollectionViewCell {
  
  var cellIndex: Int = -1
  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileTestActionControl>()

  weak var delegate: TestCollectionViewCellDelegate?

  private let testTitleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.numberOfLines = 2
    $0.lineBreakStrategy = .hangulWordPriority
    $0.lineBreakMode = .byWordWrapping
    $0.textAlignment = .center
  }

  private let testImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private lazy var optionButton1 = UIButton().then {
    $0.tag = 0
  }

  private lazy var optionButton2 = UIButton().then {
    $0.tag = 1
  }

  private lazy var optionButton3 = UIButton().then {
    $0.tag = 2
  }

  private lazy var buttonStackView = UIStackView(arrangedSubviews: [optionButton1, optionButton2, optionButton3]).then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.distribution = .fillEqually
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  private func setOptionButton(sender: UIButton, optionText: String) {
    var configuration = UIButton.Configuration.filled()
    configuration.automaticallyUpdateForSelection = false

    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)

    let handler: UIButton.ConfigurationUpdateHandler = { button in
      switch button.state {
      case .selected:
        button.configuration?.baseBackgroundColor = Colors.redL1.color
        button.configuration?.attributedTitle?.foregroundColor = Colors.red.color
        
      default:
        button.configuration?.baseBackgroundColor = Colors.g1.color
        button.configuration?.attributedTitle?.foregroundColor = Colors.black.color
      }
    }

    configuration.attributedTitle = AttributedString(optionText, attributes: container)

    sender.layer.cornerRadius = 15
    sender.layer.masksToBounds = true

    sender.configuration = configuration
    sender.configurationUpdateHandler = handler
    sender.titleLabel?.textAlignment = .center
  }

  private func render() {
    self.addSubViews([testTitleLabel, testImageView, buttonStackView])

    testTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    testImageView.snp.makeConstraints { make in
      make.top.equalTo(testTitleLabel.snp.bottom).offset(18)
      make.centerX.equalTo(testTitleLabel)
      make.width.height.equalTo(325)
    }

    buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(testImageView.snp.bottom).offset(30).multipliedBy(0.9)
      make.centerX.equalTo(testImageView)
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview().offset(-45)
    }
  }
  
  func transferToViewController(cellIndex: Int) {
    self.optionButton1.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabAnswer(answer: 1, questionNum: cellIndex + 1))
        self.optionButton1.isSelected = true
        self.optionButton2.isSelected = false
        self.optionButton3.isSelected = false
      })
      .disposed(by: disposeBag)
    
    self.optionButton2.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabAnswer(answer: 2, questionNum: cellIndex + 1))
        self.optionButton1.isSelected = false
        self.optionButton2.isSelected = true
        self.optionButton3.isSelected = false
      })
      .disposed(by: disposeBag)
    
    self.optionButton3.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabAnswer(answer: 3, questionNum: cellIndex + 1))
        self.optionButton1.isSelected = false
        self.optionButton2.isSelected = false
        self.optionButton3.isSelected = true
      })
      .disposed(by: disposeBag)
  }

  func bind(_ data: ProfileTestItemModel, _ selectedData: [Int]) {
    testTitleLabel.text = data.question
    testImageView.kf.setImage(with: URL(string: data.questionImg))

    let sequence = zip([optionButton1, optionButton2, optionButton3], data.testAnswers)

    for (button, data) in sequence {
      setOptionButton(sender: button, optionText: data.optionText)
      button.isSelected = data.isSelected
    }
  }
}
