//
//  ComicsScrollView.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation
import SwiftUI

struct ComicsScrollView: View {
    @StateObject var viewModel = ComicsCarouselViewModel()
    @State private var currentIndex: Int = 0 // Tracks the current scroll position

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.views.indices, id: \.self) { index in
                    viewModel.views[index]
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                        .onAppear {
                            if index == viewModel.views.count - 1  {
                                viewModel.fetchID()
                            }
                        }
                }
            }
        }
        .onAppear {
            viewModel.setID()
        }
    }
}

struct ComicsCarouselView_Preview: PreviewProvider {
    static var previews: some View {
        ComicsScrollView()
    }
}
