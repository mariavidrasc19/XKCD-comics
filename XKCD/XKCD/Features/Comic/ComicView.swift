//
//  ComicsView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 21.02.2025.
//

import Foundation
import SwiftUI

struct ComicView: View {
    @ObservedObject var viewModel: ComicViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(comicId: Int?) {
        self.viewModel = ComicViewModel(comicId: comicId)
    }
    
    var body: some View {
        VStack {
            if let comic = viewModel.comic {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        AsyncImage(url: URL(string: comic.img)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .cornerRadius(12)
                        .shadow(radius: 8)

                        Text(comic.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Published on \(comic.month)/\(comic.day)/\(comic.year)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(comic.alt)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)

                        if !comic.transcript.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Transcript")
                                    .font(.headline)
                                    .fontWeight(.bold)

                                Text(comic.transcript)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 8)
                        }

                        Button(action: {
                            if let url = URL(string: "https://www.explainxkcd.com/wiki/index.php/\(comic.num)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Get Explanation")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        Spacer()
                    }
                    .padding()
                }
                .navigationBarTitle(Text(comic.title), displayMode: .inline)
                .navigationBarBackButtonHidden(true) // Hide the default back button
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Custom back action
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
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
        ComicView(comicId: 3)
    }
}

