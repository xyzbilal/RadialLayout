//
//  Home.swift
//  RadialLayout
//
//  Created by Bilal SIMSEK on 25.07.2023.
//

import SwiftUI

struct Home: View {
    
    @State private var colors:[ColorValue] = [.red,.yellow,.green,.purple,.pink,.orange,.brown,.cyan,.indigo,.mint].compactMap{color -> ColorValue? in
        return .init(color: color)
    }
    @State private var activeIndex:Int = 0
    
    var body: some View {
        GeometryReader{ geometry in
            
            VStack{
               
                    Text("\(activeIndex)")
                    .font(.title.bold())
                    
                    .padding(.top,20)
               
                Spacer()
                
                RadialView(items: colors, id: \.id,spacing: 80 // Adjust this to change radius of Circles
                ) { colorValue,index,size in
                    Circle()
                        .fill(colorValue.color.gradient)
                        .overlay {
                            Text("\(index)")
                                .fontWeight(.semibold)
                        }
                } onIndexChange: { index in
                    activeIndex = index
                }
                //.padding(.horizontal, -100)
                .frame(width: geometry.size.width,height: geometry.size.width )
                
                .overlay {
                    Image(systemName: "arrow.up")
                        .font(.title2)
                        .padding(.top, 63)
                        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment:.top)
                }
              

                
                
            }
            .frame(width: .infinity,height: .infinity)
            
        }.padding(15)
    }
}

#Preview {
    ContentView()
}
