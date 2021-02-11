//
//  Carousel.swift
//  HowdySlider
//
//  Created by Rado Hečko on 17/12/2020.
//

import UIKit
import SwiftUI

@objc public class Carousel: UIView {
    
    // MARK: - Properties
    
    // Carousel properties
    @objc public var intervalInSeconds: Double = 5.0
    @objc public var enableOneDirectionScroll = false
    @objc public var enableAutoPlay = false
    @objc public var enablePageControl = true
    
    // Page controller properties
    @objc public var pageControllerColor: String = ""
    @objc public var pageControllerSelectedColor: String = ""
    @objc public var pageContollerSmallScale: CGFloat = 0
    @objc public var pageControllerCircleSize: CGFloat = 0
    @objc public var pageControllerCircleSpacing: CGFloat = 0
    @objc public var numberOfPages = 0
    
    // Cell properties
    @objc public var cellBackgroundColor: String = "#ffffff"
    @objc public var cellCornerRadius: CGFloat = 0
    @objc public var cellEnableShadow: Bool = true
    @objc public var transparent: Bool = false
    
    private var timer: Timer = Timer()
    private var firstTick = true
    private var pageControllerModel = CarouselPageControllerModel()
    private var timerOperator = "plus"
    private var alreadyVisitedIndex = 0
    private var viewItems: [UIView] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CarouselCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Exposed Methods
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc public func setupView() {
        backgroundColor = .clear
        addSubview(collectionView)
        
        collectionView.layer.masksToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        if enablePageControl {
            setPageControllerModel()
            setBottomControls()
        }
        
        if enableAutoPlay {
            start()
        }
    }

    @objc public func start() {
        timer = Timer.scheduledTimer(timeInterval: intervalInSeconds,
                                     target: self,
                                     selector: #selector(tapGestureHandler(tap:)),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
    }
    
    @objc public func stop() {
        timer.invalidate()
    }
    
    @objc public func navigatePrevious() {
        let currentIndex = pageControllerModel.currentIndex
        let nextIndex = max(currentIndex - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControllerModel.currentIndex = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc public func navigateNext() {
        let currentIndex = pageControllerModel.currentIndex
        let nextIndex = min(currentIndex + 1, numberOfPages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        pageControllerModel.currentIndex = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        alreadyVisitedIndex = max(pageControllerModel.currentIndex, alreadyVisitedIndex)
    }
    
    @objc public func setItems(items: [UIView]) {
        viewItems = items
        
        for index in 0..<items.count {
            let indexPath = IndexPath(row: index, section: 0)
            collectionView.deleteItems(at: [indexPath])
            collectionView.insertItems(at: [indexPath])
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setPageControllerModel() {
        if pageControllerSelectedColor != "" {
            let primaryColor: UIColor? = UIColor(hex: pageControllerSelectedColor)
            pageControllerModel.primaryColor = primaryColor != nil ? Color(primaryColor!) : pageControllerModel.primaryColor
        }
        
        if pageControllerColor != "" {
            let secondaryColor: UIColor? = UIColor(hex: pageControllerColor)
            pageControllerModel.secondaryColor = secondaryColor != nil ? Color(secondaryColor!) : pageControllerModel.secondaryColor
        }
        
        pageControllerModel.numberOfPages = numberOfPages
        pageControllerModel.smallScale = pageContollerSmallScale > 0 ? pageContollerSmallScale : pageControllerModel.smallScale
        pageControllerModel.circleSize = pageControllerCircleSize > 0 ? pageControllerCircleSize : pageControllerModel.circleSize
        pageControllerModel.circleSpacing = pageControllerCircleSpacing > 0 ? pageControllerCircleSpacing : pageControllerModel.circleSpacing
    }
    
    private func setBottomControls() {
        let pageController = CarouselPageController()
        let viewController = UIViewController()
        
        let uiHostingController = UIHostingController(rootView: pageController.environmentObject(pageControllerModel))
        uiHostingController.view.backgroundColor = .clear
        uiHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        uiHostingController.view.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [uiHostingController.view])
        uiHostingController.didMove(toParent: viewController)
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillProportionally
        
        addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomControlsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var index = pageControllerModel.currentIndex
        
        if index == 0 {
            timerOperator = "plus"
        }
        
        if index == numberOfPages - 1 {
            timerOperator = "minus"
        }
        
        if timerOperator == "plus" {
            index = min(index + 1, numberOfPages - 1)
        } else {
            index = max(index - 1, 0)
        }
        
        if firstTick {
            index = 0
        }
        
        let indexPathToShow = IndexPath(item: index, section: 0)
        
        collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        pageControllerModel.currentIndex = index
        alreadyVisitedIndex = max(pageControllerModel.currentIndex, alreadyVisitedIndex)
        
        firstTick = false
    }
}

extension Carousel: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPages
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCell
        let color = transparent ? UIColor.clear : UIColor(hex: cellBackgroundColor)
        cell.data = CarouselCellData(color: color, shadow: cellEnableShadow, radius: cellCornerRadius)
        
        let cellInnerView = cell.getMainView()
        
        if viewItems.count > indexPath.item {
            let customView = viewItems[indexPath.item]
            
            for subview in cellInnerView.subviews {
                subview.removeFromSuperview()
            }

            cellInnerView.addSubview(customView)
            cellInnerView.layoutIfNeeded()
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        var index = Int(x / collectionView.frame.width)
        
        if x <= 0.0 {
            index = 0
        }
        
        pageControllerModel.currentIndex = min(index, numberOfPages - 1)
        alreadyVisitedIndex = max(pageControllerModel.currentIndex, alreadyVisitedIndex)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.isScrollEnabled = true
        
        var nextIndex = pageControllerModel.currentIndex
        
        if nextIndex < alreadyVisitedIndex {
            nextIndex = alreadyVisitedIndex
        }
        
        if enableOneDirectionScroll {
            if (scrollView.contentOffset.x > collectionView.frame.width * CGFloat(nextIndex)) {
                collectionView.isScrollEnabled = false
            } else {
                collectionView.isScrollEnabled = true
                
            }
        }
    }
}
