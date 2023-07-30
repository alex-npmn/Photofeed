//
//  PhotoRepository.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import Foundation

class PhotoRepository {
    private let baseUrl = "https://api.pexels.com/v1/curated?per_page=5&page="

    func fetchPhotos(forPage page: Int) async throws -> PexelsResponse {
        guard let url = URL(string: "\(baseUrl)\(page)") else {
            throw PhotoError.invalidURL
        }

        var request = URLRequest(url: url)
        request.addValue("Q2azRzksDsemDun2AaLrvQPxUqdANgUFEMjLKQfP7Na17RSnoq03Radw",
                         forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw PhotoError.invalidResponseCode
        }

        let decodedResponse = try JSONDecoder().decode(PexelsResponse.self, from: data)
        return decodedResponse
    }

    enum PhotoError: Error {
        case invalidURL
        case invalidResponseCode
    }
}
