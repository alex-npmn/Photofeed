//
//  PhotoModel.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import Foundation
import SwiftUI

struct PhotoModel: Equatable, Identifiable {
    let width: Double
    let height: Double
    let id: Int
    let photographer: String
    let originalSizeUrl: String
    let normalSizeUrl: String
    let averageColor: Color
}

extension PhotoModel {
    init(from model: PexelsPhoto) {
        self.width = model.width
        self.height = model.height
        self.id = model.id
        self.photographer = model.photographer
        self.originalSizeUrl = model.src.original
        self.normalSizeUrl = model.src.large
        self.averageColor = Color(hex: model.avg_color)
    }
}
