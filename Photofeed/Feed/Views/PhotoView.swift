//
//  PhotoView.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import ComposableArchitecture
import SwiftUI
import SDWebImageSwiftUI

struct PhotoView: View {
    var photo: PhotoModel

    private var imageRatio: CGFloat {
        return CGFloat(photo.height) / CGFloat(photo.width)
    }

    private let imageWidth: CGFloat = UIScreen.main.bounds.width - 32 // 16 spacing on each side
    private var imageHeight: CGFloat {
        return imageWidth * imageRatio
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(photo.averageColor)
                .frame(width: imageWidth, height: imageHeight)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 4)

            WebImage(url: URL(string: photo.normalSizeUrl))
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .background(
                        ProgressView()
                )
                .cornerRadius(8)
                .frame(width: imageWidth, height: imageHeight)

            VStack {
                Spacer()
                BlurView(style: .systemUltraThinMaterialDark)
                    .frame(height: 40)
                    .overlay(
                        Text(photo.photographer)
                            .foregroundColor(.white)
                            .padding(12)
                    )
                    .cornerRadius(8)
                    .clipped()
            }
        }
        .frame(width: imageWidth)
        .padding([.leading, .trailing], 16)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
