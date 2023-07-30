//
//  PhotoDetailedFeature.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import Foundation
import ComposableArchitecture

struct PhotoDetailedFeature: Reducer {

    struct State: Equatable {
        var photo: PhotoModel
    }

    enum Action {
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
    }
}
