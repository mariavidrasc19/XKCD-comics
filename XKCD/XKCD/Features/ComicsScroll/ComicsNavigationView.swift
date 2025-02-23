//
//  ComicsNavigationView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation
import SwiftUI

struct ComicsNavigationView: View {
    @StateObject var viewModel = ComicsScrollViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.fixed(1))], spacing: 16) {
                    ForEach(viewModel.comics.indices, id: \.self) { index in
                        NavigationLink(destination: ComicView(comicId: viewModel.comics[index].num)) {
                            AsyncImage(url: URL(string: viewModel.comics[index].img)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: UIScreen.main.bounds.width,
                                   height: 400)
                            .cornerRadius(8)
                        }
                        .onAppear {
                            // Fetch more comics when the user reaches the end of the comics list
                            if index == viewModel.comics.count - 1 {
                                viewModel.fetchID()
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.setID()
            }
            .navigationBarTitle(Text("XKCD Comics"))
        }
    }
}

struct ComicsCarouselView_Preview: PreviewProvider {
    static var previews: some View {
        ComicsNavigationView()
    }
}
