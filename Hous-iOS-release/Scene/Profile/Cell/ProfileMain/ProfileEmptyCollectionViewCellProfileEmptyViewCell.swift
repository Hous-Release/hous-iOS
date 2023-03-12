//
//  ProfileEmptyCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/05.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEmptyCollectionViewCell: UICollectionViewCell {

  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileActionControl>()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }

  // MARK: UI Components

  private var emptyTitleLabel = UILabel().then {
    $0.text = "아직 나의 성향을 확인해보지 않았어요!"
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .center
  }

  private let emptyButton = UIButton().then {
    $0.setTitle("검사해보러 가기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.backgroundColor = Colors.black.color
    $0.layer.cornerRadius = 8
  }

  // MARK: Initializer

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
    transferToViewController()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    transferToViewController()
  }

  // MARK: UI Set

  private func configUI() {
    self.backgroundColor = .white
  }

  private func render() {
    addSubViews([
      emptyTitleLabel,
      emptyButton])

    emptyTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(32)
      make.centerX.equalToSuperview()
    }

    emptyButton.snp.makeConstraints { make in
      make.top.equalTo(emptyTitleLabel.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(Size.screenWidth - 48)
      make.height.equalTo(43)
    }
  }

  private func transferToViewController() {
    self.emptyButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabRetry)
      }
      .disposed(by: disposeBag)
  }

  func bind(_ data: ProfileModel) {

  }
}
