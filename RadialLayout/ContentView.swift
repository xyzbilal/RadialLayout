//
//  ContentView.swift
//  RadialLayout
//
//  Created by Bilal SIMSEK on 25.07.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("Radial Layout")
        }
    }
}

#Preview {
    ContentView()
}
