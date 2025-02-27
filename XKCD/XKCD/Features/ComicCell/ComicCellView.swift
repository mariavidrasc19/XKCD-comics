//
//  ComicsView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import SwiftUI

struct ComicCellView: View {
    @ObservedObject var viewModel: ComicCellViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(comic: Comic) {
        self.viewModel = ComicCellViewModel(comic: comic)
    }
    
    var body: some View {
        VStack {
            if let image = viewModel.comic.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    .foregroundColor(.gray)
            }
            HStack {
                Spacer()
                Button(action: {
                    viewModel.isLikeTapped()
                }) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                if let image = viewModel.comic.image {
                    ShareLink(
                        item: Image(uiImage: image),
                        preview: SharePreview(
                            "XKCD Comic Image",
                            image: Image(uiImage: image)
                        )
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }.padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.black, lineWidth: 2.5)
        )
        .frame(width: UIScreen.main.bounds.width - 30)
    }
}
