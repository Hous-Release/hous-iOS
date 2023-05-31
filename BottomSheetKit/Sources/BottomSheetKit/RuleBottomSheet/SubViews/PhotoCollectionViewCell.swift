//
//  PhotoCollectionViewCell.swift
//  
//
//  Created by 김민재 on 2023/05/30.
//

import UIKit
import SnapKit
import Then

final class PhotoCollectionViewCell: UICollectionViewCell {

    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.contentMode = .scaleToFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configurePhotoCell(_ model: RulePhoto) {
        self.imageView.image = model.image
    }
    
}
