//
//  PaginationLoaderView.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import ComposableArchitecture
import SwiftUI

struct PaginationLoaderView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
    }
}
