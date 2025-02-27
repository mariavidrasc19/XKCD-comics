//
//  ComicDetailView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 26.02.2025.
//

import Foundation
import SwiftUI

struct ComicDetailView: View {
    @ObservedObject var viewModel: ComicDetailViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(comic: Comic) {
        self.viewModel = ComicDetailViewModel(comic: comic)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(String(viewModel.comic.id) + ". " + viewModel.comic.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
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
                        if let url = URL(string: "https://www.explainxkcd.com/wiki/index.php/\(viewModel.comic.id)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Get Explanation")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle(Text(viewModel.comic.title), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.isLikeTapped()
                        }) {
                            Image(systemName: viewModel.getImage(comicId: viewModel.comic.id))
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
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
