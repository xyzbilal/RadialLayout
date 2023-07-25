//
//  RadialView.swift
//  RadialLayout
//
//  Created by Bilal SIMSEK on 25.07.2023.
//

import SwiftUI

struct RadialView<Content: View, Item:RandomAccessCollection, ID:Hashable>:View where Item.Element:Identifiable {
    
    var content:(Item.Element,Int,CGFloat)->Content
    var keypadID: KeyPath<Item.Element,ID>
    var items:Item
    var spacing:CGFloat?
    var onIndexChange:(Int)->()
    
    @State private var dragRotation:Angle = .zero
    @State private var lastDragRotation:Angle = .zero
    @State private var activeIndex:Int = 0
    
    init(items:Item,id: KeyPath<Item.Element,ID>, spacing:CGFloat? = nil, @ViewBuilder content:@escaping (Item.Element,Int,CGFloat)->Content,onIndexChange:@escaping (Int)->()) {
        self.content = content
        self.keypadID = id
        self.items = items
        self.spacing = spacing
        self.onIndexChange = onIndexChange
    }
    var body: some View {
        GeometryReader{ geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            let spacing:CGFloat = spacing ?? 0
            
            let viewSize = (width - spacing) / (count / 2)
            
            ZStack{
                ForEach(items) { item in
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index) / count) * 360.0
                    
                    content(item,index, viewSize)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(.init(degrees: -rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width:viewSize,height: viewSize)
                        .offset(x:(width - viewSize) / 2)
                        .rotationEffect(.init(degrees: -90))
                        .rotationEffect(.init(degrees: rotation))
                }
                
            }
            .frame(width: width,height: width)
            .contentShape(.rect)
            .rotationEffect(dragRotation)
            .gesture(DragGesture()
                .onChanged({ value in
                    let translationX = value.translation.width
                    let progress = translationX / (viewSize * 3)
                    let rotationFraction = 360.0 / count
                    
                    dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                    
                }).onEnded({ value in
                    
                    let velocityX = value.velocity.width /  15
                    let translationX = value.translation.width + velocityX
                    let progress = (translationX / viewSize).rounded()
                    let rotationFraction = 360.0 / count
                    withAnimation(.snappy) {
                        dragRotation = .init(degrees: (rotationFraction * progress) + lastDragRotation.degrees)
                    }
                   
                  
                    lastDragRotation = dragRotation
                    calculateIndex(count)
                })
            
            )
            
        }
    }
    
    func calculateIndex(_ count:CGFloat){
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded().truncatingRemainder(dividingBy: count)
        
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : count - activeIndex)
        self.activeIndex = Int(activeIndex)
        onIndexChange(self.activeIndex)
    }
    
    func fetchIndex(_ item:Item.Element) -> Int{
        if let index = items.firstIndex(where: { $0.id == item.id
        }) as? Int{
            return index
        }
        return 0
    }
    
}

#Preview {
    ContentView()
}
