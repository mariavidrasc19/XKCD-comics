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
                if searchText.isEmpty {
                    Task {
                        try await viewModel.loadData()
                    }
                } else {
                    Task {
                        await viewModel.searchComics(query: searchText)
                    }
                }
            }
            .onAppear {
                Task {
                    try await viewModel.loadData()
                }
            }
            .navigationBarTitle(Text("XKCD Comics"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.getFavorites()
                        }
                    }) {
                        Text("Favorites")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Task {
                            try await viewModel.getBrowsing()
                        }
                    }) {
                        Text("Browse")
                    }
                }
            }
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
            ProgressView()
                .padding()
        case .loaded(let comics):
            comicsView(comics: comics)
        case .searchResults(let comics):
            comicsView(comics: comics)
        case .favorites(let comics):
            comicsView(comics: comics)
        case .error(let string):
            Text(string)
                .foregroundStyle(.red)
                .padding()
        }
    }
    
    func comicsView(comics: [Comic]) -> some View {
        VStack {
            LazyVGrid(columns: [GridItem(.fixed(1))], spacing: 16) {
                ForEach(comics.indices, id: \.self) { index in
                    comicCellView(comic: comics[index])
                        .onAppear() {
                            // Fetch more comics when the user reaches the end of the comics list
                            if index == comics.count - 1 {
                                Task {
                                    try await viewModel.fetchNextComic()
                                }
                            }
                        }
                }
            }
        }
    }
    
    func comicCellView(comic: Comic) -> some View {
        NavigationLink(destination: ComicDetailView(comic: comic)) {
            ComicCellView(comic: comic)
        }
    }
}

struct ComicsCarouselView_Preview: PreviewProvider {
    static var previews: some View {
        ComicsNavigationView()
    }
}
