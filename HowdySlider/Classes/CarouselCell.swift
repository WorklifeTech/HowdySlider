//
//  CarouselCell.swift
//  HowdySlider
//
//  Created by Rado Hečko on 17/12/2020.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    var data: CarouselCellData? {
        didSet {
            guard let data = data else { return }
            mainView.backgroundColor = data.color
            mainView.layer.cornerRadius = data.radius
            
            if !data.shadow {
                contentView.addShadow(offset: CGSize.init(width: 0, height: 0),
                                      color: UIColor.clear,
                                      radius: 0,
                                      opacity: 0)
            }
        }
    }
    
    fileprivate let mainView: UIView = {
        let uiView = UIView()
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.layer.masksToBounds = true
        
        return uiView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(mainView)
        contentView.layer.masksToBounds = false
        contentView.addShadow(offset: CGSize.init(width: mainView.frame.width, height: mainView.frame.height),
                              color: UIColor.black,
                              radius: 6.0,
                              opacity: 0.65)
        
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func getMainView() -> UIView {
        return mainView
    }
    
    public func setSubViews(subview: UIView) {
        mainView.addSubview(subview)
        
        subview.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }
}
