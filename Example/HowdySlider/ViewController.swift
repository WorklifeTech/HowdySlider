//
//  ViewController.swift
//  HowdySlider
//
//  Created by radohecko on 12/17/2020.
//  Copyright (c) 2020 radohecko. All rights reserved.
//

import UIKit
import HowdySlider

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let carousel = Carousel(frame: CGRect(x: 10, y: 60, width: view.frame.width - 20, height: view.frame.width / 2))
        
        carousel.numberOfPages = 3
        carousel.cellCornerRadius = 12.0
        carousel.cellBackgroundColor = "#ffffff"
        carousel.cellEnableShadow = true
        carousel.enableAutoPlay = true
        carousel.enableOneDirectionScroll = false
        carousel.enablePageControl = true
        
        carousel.setupView()
        
        view.addSubview(carousel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

