//
//  ContentView.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SinglePickerView()
                .tabItem {
                    Label("Single", systemImage: "heart")
                }
            
            MultilPickerView()
                .tabItem {
                    Label("Multil", systemImage: "heart")
                }
        }
        
        
        
    }
}

#Preview {
    ContentView()
}
