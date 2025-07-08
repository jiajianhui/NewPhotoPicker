//
//  PhotoPickerViewModel.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI
import PhotosUI


@MainActor // 这个类里的所有代码默认都在主线程（Main Thread）上执行；SwiftUI 的 UI 更新只能在主线程进行（图片的更新变化）
class PhotoPickerViewModel: ObservableObject {
    
    // 一个图片
    @Published var image: Image?
    @Published var selectedPhoto: PhotosPickerItem? {
        // 属性观察器，它在属性值 被设置（set）之后立刻调用
        didSet {
            if let selectedPhoto { // 简化写法，等价于if let selectedPhoto = selectedPhoto，叫做 简化的 Optional 绑定
                Task {
                    // 调用 throws 函数时必须用 try 显式处理错误，否则编译不通过。
                    try? await loadtransFerable(from: selectedPhoto)
                }
            }
        }
    }
    
    // 多张图片
    @Published var images: [Image] = []
    @Published var selectedPhotos: [PhotosPickerItem] = [] {
        didSet {
            if !selectedPhotos.isEmpty {
                Task {
                    try? await loadtransFerable(from: selectedPhotos)
                    selectedPhotos = []
                }
            }
        }
    }
    
    
    // 将图片选择器中的图片进行数据转换
    // loadTransferable(type:) 是一个可能抛出错误的异步函数，所以要使用async throws；若无需捕获错误，使用try?可以进行简化
    func loadtransFerable(from selectedImage: PhotosPickerItem?) async throws {
        do {
            if let data = try await selectedImage?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.image = Image(uiImage: uiImage)
            }
            
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }
    
    
    
    func loadtransFerable(from selectedImages: [PhotosPickerItem]) async throws {
        do {
            for selectedImage in selectedImages {
                
                if let data = try await selectedImage.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.images.append(Image(uiImage: uiImage))
                }
            }
            
        } catch {
            print(error.localizedDescription)
            images = []
        }
    }
}
