//
//  FeedView.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import ComposableArchitecture
import SwiftUI
import SDWebImageSwiftUI

struct FeedView: View {
    let store: StoreOf<FeedFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    List {
                        ForEach(viewStore.photos) { photo in
                            PhotoView(photo: photo)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    viewStore.send(.photoSelected(photo))
                                }
                        }

                        // Loader for Pagination
                        if !viewStore.isLoading && !viewStore.photos.isEmpty {
                            PaginationLoaderView()
                                .onAppear(perform: {
                                    viewStore.send(.fetchPhotos)
                                })
                        }
                    }
                    .listStyle(.inset)
                    .refreshable { viewStore.send(.pullToRefresh) }
                    .navigationTitle("Feed")
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationDestination(
                        isPresented: viewStore.binding(
                            get: { $0.detailedState != nil },
                            send: FeedFeature.Action.dismissPhotoDetail
                        ),
                        destination: {
                            IfLetStore(
                                self.store.scope(
                                    state: { $0.detailedState },
                                    action: FeedFeature.Action.detailedPhoto
                                ),
                                then: { scopedStore in
                                    PhotoDetailedView(store: scopedStore)
                                }
                            )
                        }
                    )

                    if viewStore.isLoading && viewStore.photos.isEmpty {
                        ProgressView().scaleEffect(1.5)
                    }

                    if let message = viewStore.errorMessage {
                        ErrorView(retryAction: {
                            viewStore.send(.fetchPhotos)
                        }, errorMessage: message)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    }
                }
                .onAppear(perform: {
                    viewStore.send(.fetchPhotos)
                })
            }
        }
    }
}
