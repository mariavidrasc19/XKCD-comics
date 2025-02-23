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
                        NavigationLink(destination: ComicView(comic: viewModel.comics[index])) {
                            VStack {
                                AsyncImage(url: URL(string: viewModel.comics[index].img)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                HStack {
                                    Spacer()
                                    Button(action: {}) {
                                        Image(systemName: viewModel.getImage(for: viewModel.comics[index].num))
                                    }
                                    ShareLink(
                                        item: viewModel.comics[index].link,
                                        message: Text("Check out this XKCD comic: \(viewModel.comics[index].title)")
                                    ) {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    .padding()
                                }
                            }
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 2.5)
                            )
                            .frame(width: UIScreen.main.bounds.width - 30)
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
