//
//  RuleGuideCollectionViewCell.swift
//  
//
//  Created by 김민재 on 2/11/24.
//

import UIKit

import SnapKit
import AssetKit
import Lottie

final class RuleGuideCollectionViewCell: UICollectionViewCell {
    
    static let id = "RuleGuideCollectionViewCell"
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
        label.textColor = Colors.black.color
        return label
    }()
    
    private var guideLottieView = AnimationView().then {
      $0.loopMode = .loop
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
    }
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
        label.textColor = Colors.g4.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        [titleLabel, guideLottieView, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        guideLottieView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.size.equalTo(122)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLottieView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configGuideCell(
        title: String,
        lottie: String,
        description: String
    ) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.guideLottieView.animation = Animation.named(lottie)
        playLottie()
    }
    
    private func playLottie() {
      guideLottieView.currentProgress = 0
        guideLottieView.play()
    }
    
}
