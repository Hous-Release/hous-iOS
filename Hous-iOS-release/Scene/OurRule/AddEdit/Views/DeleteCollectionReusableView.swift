//
//  DeleteCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit

final class DeletePhotoCollectionReusableView: UICollectionReusableView {

    var buttonTappedClosure: (() -> Void)?

    private lazy var deleteButton = UIButton().then {
        $0.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
      $0.setImage(Images.icDelete.image, for: .normal)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        self.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DeletePhotoCollectionReusableView {
    @objc func didTapDeleteButton() {
        buttonTappedClosure?()
    }
}
