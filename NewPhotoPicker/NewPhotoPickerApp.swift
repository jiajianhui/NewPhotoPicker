//
//  NewPhotoPickerApp.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/8.
//

import SwiftUI
import SwiftData

@main
struct NewPhotoPickerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Photo.self)
        }
    }
}
