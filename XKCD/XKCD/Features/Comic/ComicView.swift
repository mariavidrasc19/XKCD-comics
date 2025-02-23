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
    
    init(comic: Comic) {
        self.viewModel = ComicViewModel(comic: comic)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncImage(url: URL(string: viewModel.comic.img)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(12)
                    .shadow(radius: 8)

                    Text(viewModel.comic.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Published on \(viewModel.comic.month)/\(viewModel.comic.day)/\(viewModel.comic.year)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(viewModel.comic.alt)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.vertical, 8)

                    if !viewModel.comic.transcript.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Transcript")
                                .font(.headline)
                                .fontWeight(.bold)

                            Text(viewModel.comic.transcript)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 8)
                    }

                    Button(action: {
                        if let url = URL(string: "https://www.explainxkcd.com/wiki/index.php/\(viewModel.comic.num)") {
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
            .navigationBarTitle(Text(viewModel.comic.title), displayMode: .inline)
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Toggle the value of the `isLiked` variable when the button is tapped
                        viewModel.isLikeTapped()
                    }) {
                        // Use an image or label to indicate that the button is a "like" button
                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    }
                }
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
        }
    }
}

//{"month": "1", "num": 3, "link": "", "year": "2006", "news": "", "safe_title": "Island (sketch)", "transcript": "[[A sketch of an Island]]\n{{Alt:Hello, island}}", "alt": "Hello, island", "img": "https://imgs.xkcd.com/comics/island_color.jpg", "title": "Island (sketch)", "day": "1"}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComicView(comicId: 3)
//    }
//}

