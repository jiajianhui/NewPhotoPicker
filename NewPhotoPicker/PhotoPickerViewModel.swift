//
//  PhotoPickerViewModel.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI
import PhotosUI

import SwiftData

@MainActor // 这个类里的所有代码默认都在主线程（Main Thread）上执行；SwiftUI 的 UI 更新只能在主线程进行（图片的更新变化）
class PhotoPickerViewModel: ObservableObject {
    
    
    // 一个图片
    @Published var selectedPhoto: PhotosPickerItem?

    
    // 将图片选择器中的图片进行数据转换
    // loadTransferable(type:) 是一个可能抛出错误的异步函数，所以要使用async throws；若无需捕获错误，使用try?可以进行简化
    func loadtransFerable(from selectedImage: PhotosPickerItem?, context: ModelContext) async throws {
        do {
            if let data = try await selectedImage?.loadTransferable(type: Data.self){
                // 存入数据库
                let photo = Photo(image: data)
                context.insert(photo)
                try? context.save()
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    // 多张图片
    @Published var selectedPhotos: [PhotosPickerItem] = []
    
    func loadtransFerable(from selectedImages: [PhotosPickerItem], context: ModelContext) async throws {
        do {
            for selectedImage in selectedImages {
                
                if let data = try await selectedImage.loadTransferable(type: Data.self) {
                    // 存入数据库
                    let photo = Photo(image: data)
                    context.insert(photo)
                    try? context.save()
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
