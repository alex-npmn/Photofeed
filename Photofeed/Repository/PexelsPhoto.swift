//
//  PexelsPhoto.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import Foundation

struct PexelsResponse: Codable {
    let page: Int
    let per_page: Int
    let photos: [PexelsPhoto]
    let next_page: String
}

struct PexelsPhoto: Codable {
    let width: Double
    let height: Double
    let id: Int
    let avg_color: String
    let url: String
    let photographer: String
    let src: Src
}

struct Src: Codable, Equatable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}
