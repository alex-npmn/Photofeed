//
//  PhotofeedApp.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct PhotofeedApp: App {
    static let store = Store(initialState: FeedFeature.State()) {
      FeedFeature()._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            FeedView(store: PhotofeedApp.store)
        }
    }
}
