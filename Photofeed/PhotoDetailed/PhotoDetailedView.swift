//
//  PhotoDetailedView.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct PhotoDetailedView: View {
    let store: StoreOf<PhotoDetailedFeature>

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var imageLoaded = false

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                GeometryReader { geometry in
                    WebImage(url: URL(string: viewStore.photo.originalSizeUrl))
                        .onSuccess { _, _, _ in
                            imageLoaded = true
                        }
                        .resizable()
                        .indicator(.activity)
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture().onChanged { value in
                                    if imageLoaded {
                                        scale = lastScale * value
                                    }
                                }.onEnded { _ in
                                    if imageLoaded {
                                        fixOffsetAndScale(geometry: geometry)
                                    }
                                },
                                DragGesture().onChanged { gesture in
                                    if imageLoaded {
                                        var newOffset = lastOffset
                                        newOffset.width += gesture.translation.width
                                        newOffset.height += gesture.translation.height
                                        offset = newOffset
                                    }
                                }.onEnded { _ in
                                    if imageLoaded {
                                        fixOffsetAndScale(geometry: geometry)
                                    }
                                }
                            )
                        )
                }
            }
            .navigationTitle(viewStore.photo.photographer)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func fixOffsetAndScale(geometry: GeometryProxy) {
        let newScale: CGFloat = .minimum(.maximum(scale, 1), 4)
        let screenSize = geometry.size

        let widthLimit: CGFloat = max((screenSize.width * newScale - screenSize.width) / 2, 0)
        let heightLimit: CGFloat = max((screenSize.height * newScale - screenSize.height) / 2, 0)

        let newOffset = CGSize(
            width: min(max(offset.width, -widthLimit), widthLimit),
            height: min(max(offset.height, -heightLimit), heightLimit)
        )

        lastScale = newScale
        lastOffset = newOffset

        withAnimation() {
            offset = newOffset
            scale = newScale
        }
    }
}
