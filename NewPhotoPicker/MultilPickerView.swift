//
//  SinglePickerView.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI
import PhotosUI
import SwiftData

struct MultilPickerView: View {
    
    @StateObject private var vm = PhotoPickerViewModel()
    
    // 查询数据库
    @Query(sort: \Photo.createAt, order: .reverse) var photos: [Photo]
    
    @Environment(\.modelContext) var context
    
    let cols = [
        GridItem(.flexible(), spacing: 16), // 控制列之间的距离
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: cols, spacing: 16) { // 控制行之间的距离
                    
                    // vm.images 是一个非可选类型的数组，不能用if let，因为if let 只能用于可选类型的绑定
                    if !photos.isEmpty {
                        ForEach(0..<photos.count, id: \.self) { index in
                            Rectangle()
                                .aspectRatio(1, contentMode: .fit)
                                
                                .overlay {
                                    if let data = photos[index].image,
                                       let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .aspectRatio(1, contentMode: .fit)
                                    }
                                }
                            
                                // 先裁剪，然后再叠加描边。否则会有黑色描边
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white, lineWidth: 2)
                                }
                            
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
                                
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            .navigationTitle("MultilPicker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $vm.selectedPhotos, matching: .images) {
                        Image(systemName: "photo.badge.plus")
                    }

                }
            }
            
            // 监听数据
            .onChange(of: vm.selectedPhotos) { oldValue, newValue in
                Task {
                    if !newValue.isEmpty {
                        try? await vm.loadtransFerable(from: vm.selectedPhotos, context: context)
                        vm.selectedPhotos = []
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MultilPickerView()
    }
}
