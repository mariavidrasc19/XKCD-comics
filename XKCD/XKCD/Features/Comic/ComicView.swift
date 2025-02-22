//
//  ComicsView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import SwiftUI

struct ComicView: View {
    @StateObject var viewModel = ComicViewModel()
    
    var body: some View {
        VStack {
            if let comic = viewModel.comic {
                Text(comic.title)
                        .font(.headline)
                    
                AsyncImage(url: URL(string: comic.img)) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)

                Text(comic.alt)
                        .font(.caption)
                        .padding()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Text("Error: \(viewModel.errorMessage ?? "Unknown")")
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView()
    }
}

