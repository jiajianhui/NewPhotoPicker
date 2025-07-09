//
//  SinglePickerView.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI
import PhotosUI
import SwiftData

struct SinglePickerView: View {
    
    @StateObject private var vm = PhotoPickerViewModel()
    
    // 查询数据库
    @Query(sort: \Photo.createAt, order: .reverse) var photos: [Photo]
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack {
            VStack {
                if let data = photos.first?.image,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
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
        .onChange(of: vm.selectedPhoto) { oldValue, newValue in
            Task {
                try? await vm.loadtransFerable(from: vm.selectedPhoto, context: context)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SinglePickerView()
    }
}
