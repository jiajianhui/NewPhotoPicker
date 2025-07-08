//
//  SinglePickerView.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI
import PhotosUI

struct SinglePickerView: View {
    
    @StateObject private var vm = PhotoPickerViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = vm.image {
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
            .navigationTitle("SinglePicker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $vm.selectedPhoto) {
                        Image(systemName: "photo.badge.plus")
                    }

                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SinglePickerView()
    }
}
