//
//  ErrorView.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import ComposableArchitecture
import SwiftUI

struct ErrorView: View {
    var retryAction: () -> Void
    var errorMessage: String

    private let width: CGFloat = UIScreen.main.bounds.width - 32
    private let height: CGFloat = 200

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .frame(width: width, height: height)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)

            VStack(spacing: 20) {
                Text(errorMessage)
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .foregroundColor(Color(.label))
                    .multilineTextAlignment(.center)

                Button(action: retryAction) {
                    Text("Retry")
                        .font(.system(size: 17))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .foregroundColor(Color.blue)
                }
            }
            .padding([.leading, .trailing], 20)
        }
        .frame(width: width)
        .padding([.leading, .trailing], 16)
    }
}
