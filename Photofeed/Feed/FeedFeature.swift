//
//  FeedFeature.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct FeedFeature: Reducer {

    struct State: Equatable {
        var currentPage: Int = 1
        var photos: [PhotoModel] = []
        var isLoading: Bool = true
        var hasNextPage = true
        var errorMessage: String?

        var detailedState: PhotoDetailedFeature.State?
    }

    enum Action {
        case fetchPhotos
        case pullToRefresh
        case photoSelected(PhotoModel)
        case detailedPhoto(PhotoDetailedFeature.Action)
        case dismissPhotoDetail
        case internalAction(InternalAction)
    }

    enum InternalAction {
        case incrementPage
        case setPhotos([PhotoModel])
        case loadFailed(String)
        case dismissError
        case hasNextPage(Bool)
        case dismissPhotoDetail
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchPhotos:
            state.errorMessage = nil
            return fetchPhotosEffect(page: state.currentPage)

        case .pullToRefresh:
            state.errorMessage = nil
            state.isLoading = true
            state.photos = []
            state.currentPage = 1
            return fetchPhotosEffect(page: state.currentPage)

        case .photoSelected(let photo):
            state.detailedState = PhotoDetailedFeature.State(photo: photo)
            return .none

        case .detailedPhoto:
            return .none

        case .dismissPhotoDetail:
            state.detailedState = nil
            return .none

        case .internalAction(let internalAction):
            return handleInternalAction(internalAction, &state)
        }
    }
}

// MARK: - Private methods
private extension FeedFeature {
    func handleInternalAction(_ action: InternalAction, _ state: inout State) -> Effect<Action> {
        switch action {
        case .incrementPage:
            state.currentPage += 1
            return .none

        case .setPhotos(let photos):
            state.isLoading = false
            state.photos.append(contentsOf: photos)
            return .none

        case .loadFailed(let error):
            state.isLoading = false
            state.errorMessage = error
            return .none

        case .dismissError:
            state.errorMessage = nil
            return .send(.fetchPhotos)

        case .hasNextPage(let result):
            state.hasNextPage = result
            return .none

        case .dismissPhotoDetail:
            state.detailedState = nil
            return .none
        }
    }

    func fetchPhotosEffect(page: Int) -> Effect<Action> {
        return .run { send in
            do {
                let response = try await PhotoRepository().fetchPhotos(forPage: page)
                await send(.internalAction(.hasNextPage(!response.next_page.isEmpty)))
                await send(.internalAction(.incrementPage))
                let photos = response.photos.map { PhotoModel(from: $0) }
                await send(.internalAction(.setPhotos(photos)))
            } catch {
                await send(.internalAction(.loadFailed(error.localizedDescription)))
            }
        }
    }
}
