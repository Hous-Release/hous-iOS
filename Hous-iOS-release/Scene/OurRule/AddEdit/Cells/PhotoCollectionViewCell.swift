//
//  PhotoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

  private let imageView = UIImageView().then {
    $0.contentMode = .scaleToFill
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
    setStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    self.layer.cornerRadius = 8
    self.clipsToBounds = true
  }

  private func setLayout() {
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func configPhotoCell(image: UIImage) {
    imageView.image = image
  }

}
