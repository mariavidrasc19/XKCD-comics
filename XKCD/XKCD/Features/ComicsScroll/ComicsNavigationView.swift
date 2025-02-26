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
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                contentView
            }
            .searchable(text: $searchText, prompt: "Search comics")
            .onChange(of: searchText) {
                Task {
                    await viewModel.searchComics(query: searchText)
                }
            }
            .onAppear {
                Task {
                    try await viewModel.loadData()
                }
            }
            .navigationBarTitle(Text("XKCD Comics"))
        }
    }
}

extension ComicsNavigationView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView().padding()
        case .loaded(let comics):
            if viewModel.searchResults.isEmpty {
                comicsView(comics: comics)
            } else {
                comicsView(comics: viewModel.searchComics)
            }
        case .error(let string):
            Text(string).foregroundStyle(.red)
        }
    }
    
    func comicsView(comics: [Comic]) -> some View {
        LazyVGrid(columns: [GridItem(.fixed(1))], spacing: 16) {
            ForEach(comics.indices, id: \.self) { index in
                comicCellView(comic: comics[index])
                    .onAppear {
                        // Fetch more comics when the user reaches the end of the comics list
                        if viewModel.searchResults.isEmpty,
                           index == comics.count - 1 {
                            Task {
                                try await viewModel.fetchNextComic()
                            }
                        }
                    }
            }
        }
    }
    
    func comicCellView(comic: Comic) -> some View {
        NavigationLink(destination: ComicView(comic: comic)) {
            VStack {
                if let image = comic.image {
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
                    Button(action: {}) {
                        Image(systemName: viewModel.getImage(for: comic.num))
                    }
                    ShareLink(
                        item: comic.link,
                        message: Text("Check out this XKCD comic: \(comic.title)")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .padding()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black, lineWidth: 2.5)
            )
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    }
}

struct ComicsCarouselView_Preview: PreviewProvider {
    static var previews: some View {
        ComicsNavigationView()
    }
}
