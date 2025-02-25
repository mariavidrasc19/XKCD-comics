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
                    await viewModel.loadData()
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
            EmptyView()
        case .loaded(let comics):
            comicsView(comics: comics)
        case .error(let string):
            Text(string).foregroundStyle(.red)
        }
    }
    
    func comicsView(comics: [Comic]) -> some View {
        LazyVGrid(columns: [GridItem(.fixed(1))], spacing: 16) {
            ForEach(comics.indices, id: \.self) { index in
                NavigationLink(destination: ComicView(comic: comics[index])) {
                    VStack {
                        if let image = comics[index].image {
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
                                Image(systemName: viewModel.getImage(for: comics[index].num))
                            }
                            ShareLink(
                                item: comics[index].link,
                                message: Text("Check out this XKCD comic: \(comics[index].title)")
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
                .onAppear {
                    // Fetch more comics when the user reaches the end of the comics list
                    if index == comics.count - 1 {
                        Task {
                            await viewModel.fetchNextComic()
                        }
                    }
                }
            }
        }
    }
}

struct ComicsCarouselView_Preview: PreviewProvider {
    static var previews: some View {
        ComicsNavigationView()
    }
}
