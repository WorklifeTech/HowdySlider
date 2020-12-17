//
//  CarouselPageController.swift
//  HowdySlider
//
//  Created by Rado Hečko on 17/12/2020.
//

import SwiftUI

class CarouselPageControllerModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var numberOfPages = 3
    @Published var circleSize: CGFloat = 15
    @Published var circleSpacing: CGFloat = 5
    @Published var smallScale: CGFloat = 0.7
    @Published var primaryColor = Color(UIColor(hex: "#9D9D9D"))
    @Published var secondaryColor = Color(UIColor(hex: "#DBDBDB"))
}

struct CarouselPageController: View {
    @EnvironmentObject var model: CarouselPageControllerModel
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: model.circleSpacing) {
            ForEach(0..<model.numberOfPages) { index in // 1
                if shouldShowIndex(index: index, max: model.numberOfPages) {
                    Circle()
                        .fill(model.currentIndex == index ? model.primaryColor : model.secondaryColor)
                        .scaleEffect(model.currentIndex == index ? 1 : model.smallScale)
                        .frame(width: model.circleSize, height: model.circleSize)
                        .transition(AnyTransition.opacity.combined(with: .scale))
                        .id(index)
                        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .animation(.default)
        .background(Color.clear)
    }
    
    // MARK: - Private Methods
    private func shouldShowIndex(index: Int, max: Int) -> Bool {
        let close = index <= max && abs(index - model.currentIndex) <= 2
        let leftEdge = model.currentIndex <= 1 && index <= 4
        let rightEdge = max - model.currentIndex <= 2 && max - index <= 4
        
        return close || leftEdge || rightEdge
    }
}

struct CarouselPageController_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPageController().environmentObject(CarouselPageControllerModel())
    }
}
