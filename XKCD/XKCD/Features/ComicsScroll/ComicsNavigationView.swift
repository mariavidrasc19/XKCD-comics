//
//  ComicsNavigationView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation
import SwiftUI

struct ComicsNavigationView: View {
    @StateObject var viewModel = ComicsNavigationViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // buttons for browsing and look up favorites
                    HStack(spacing: 16) {
                        Button(action: {
                            Task {
                                try await viewModel.getBrowsing()
                            }
                        }) {
                            Text("Browse")
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            Task {
                                await viewModel.getFavorites()
                            }
                        }) {
                            Text("Favorites")
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // contains the comics
                    contentView
                }
                .searchable(text: $searchText, prompt: "Search comics")
                .navigationBarTitle(Text("XKCD Comics"))
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
            }
        }
    }
}

extension ComicsNavigationView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .loading:
            VStack {
                Image(uiImage: .xkcd)
                    .resizable()
                    .scaledToFit()
                    .padding()
                ProgressView()
                    .padding()
            }
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
                            if case .loaded = viewModel.state,
                                index == comics.count - 1 {
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
