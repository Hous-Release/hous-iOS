//
//  ProfileDetailNavigationView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import HousUIComponent

final class ProfileDetailNavigationBarView: NavBarWithBackButtonView {

  private let disposeBag: DisposeBag = DisposeBag()
  let viewActionControlSubject = PublishSubject<ProfileDetailActionControl>()
  var isFromTypeTest: Bool = false

  private let imageDownloadButton = UIButton().then {
    $0.setImage(Images.icImageDownload.image, for: .normal)
  }

  private let titleName = UILabel().then {
    $0.text = "성향 자세히 보기"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textAlignment = .center
  }

  init(title: String = "",
       rightButtonText: String = "",
       rightButtonImage: UIImage? = nil,
       isSeparatorLineHidden: Bool = true,
       isFromTypeTest: Bool
  ) {
    super.init(title: title, rightButtonText: rightButtonText,
               rightButtonImage: rightButtonImage,
               isSeparatorLineHidden: isSeparatorLineHidden)
    self.isFromTypeTest = isFromTypeTest
    render()
    setup()
    transferToViewController()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.backgroundColor = .white
  }

  private func render() {

    self.addSubview(imageDownloadButton)

    imageDownloadButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(24)
    }
  }

  private func transferToViewController() {
    self.backButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabBack)
      }
      .disposed(by: disposeBag)

    self.imageDownloadButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabBack)
      }
      .disposed(by: disposeBag)
  }
}
