//
//  RuleGuideBottomSheetView.swift
//
//
//  Created by 김민재 on 2/11/24.
//

import UIKit
import SnapKit
import AssetKit

final class RuleGuideBottomSheetView: UIView {
    
    private typealias SECTION = RuleBottomDataSource.Section
    private typealias ITEM = RuleBottomDataSource.Item
    private typealias DataSource = UICollectionViewDiffableDataSource<SECTION, ITEM>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<SECTION, ITEM>
    private typealias CellReigstration = UICollectionView.CellRegistration

    private enum Size {
        static let leadingTrailingOffset: CGFloat = 70
        static let stackViewVerticalSpacing: CGFloat = 16
        static let stackViewLeadingTrailing: CGFloat = 24
        static let handlerWidth: CGFloat = 80
        static let handlerHeight: CGFloat = 5
        static let guideCellCount = 3
    }
    
    private let titles = [
        "룰스 고정하기1",
        "룰스 고정하기2",
        "룰스 고정하기3"
    ]
    
    private let lotties = [
        "guide_second",
        "guide_second",
        "guide_third"
    ]
    
    private let descriptions = [
        "룰스를 고정하려면 어쩌구저쩌구1",
        "룰스를 고정하려면 어쩌구저쩌구2",
        "룰스를 고정하려면 어쩌구저쩌구3"
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }

    private let rootView: UIView = {
      let view = UIView()
      view.layer.cornerRadius = 20
        view.backgroundColor = Colors.white.color
      view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      return view
    }()

    private let handlerView: UIView = {
      let view = UIView()
      view.backgroundColor = Colors.g3.color
      view.layer.cornerCurve = .continuous
      view.layer.cornerRadius = 5
      return view
    }()

    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.register(RuleGuideCollectionViewCell.self, forCellWithReuseIdentifier: RuleGuideCollectionViewCell.id)
        return cv
    }()
    
    private let pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.numberOfPages = Size.guideCellCount
        pc.pageIndicatorTintColor = Colors.g3.color
        pc.currentPageIndicatorTintColor = Colors.blue.color
        return pc
    }()

    init() {
        super.init(frame: .zero)
        setUI()
        setHierarchy()
        setLayout()
        setCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
    }
    
    private func setHierarchy() {
        self.addSubview(rootView)
        [handlerView, collectionView, pageControl].forEach {
            rootView.addSubview($0)
        }
        
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setLayout() {
        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        handlerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
            make.width.equalTo(Size.handlerWidth)
            make.height.equalTo(Size.handlerHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(handlerView.snp.bottom).offset(24)
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(86)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(18)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    
}

extension RuleGuideBottomSheetView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}

extension RuleGuideBottomSheetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Size.guideCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RuleGuideCollectionViewCell.id, for: indexPath) as? RuleGuideCollectionViewCell else { return UICollectionViewCell() }
        cell.configGuideCell(title: titles[indexPath.row], lottie: lotties[indexPath.row], description: descriptions[indexPath.row])
        return cell
    }
    
    
}
