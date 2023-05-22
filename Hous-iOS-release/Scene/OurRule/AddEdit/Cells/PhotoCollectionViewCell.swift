//
//  PhotoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit
import RxSwift

final class PhotoCollectionViewCell: UICollectionViewCell {

  var buttonTapSubject = PublishSubject<Void>()

  var disposeBag = DisposeBag()

  private lazy var deleteButton = UIButton().then {
    $0.setImage(Images.icDelete.image, for: .normal)
  }

  private let imageView = UIImageView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.contentMode = .scaleToFill
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    bind()
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setLayout() {
    contentView.addSubViews([imageView, deleteButton])
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(5)
    }

    deleteButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(-3)
      make.trailing.equalToSuperview().offset(3)
    }

  }

  func configPhotoCell(image: UIImage) {
    imageView.image = image
  }

}

extension PhotoCollectionViewCell {
  func bind() {
    deleteButton.rx.tap
      .subscribe(onNext: {
        self.buttonTapSubject.onNext(())
      })
      .disposed(by: disposeBag)
  }
}
