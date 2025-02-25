//
//  ComicsCarouselViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation

enum ComicsScrollViewState {
    case idle // Starea inițială, înainte de a începe încărcarea
    case loading // Încărcare în curs
    case loaded([Comic]) // Încărcare finalizată cu succes
    case error(String) // Eroare cu un mesaj
}

@MainActor
class ComicsScrollViewModel: ObservableObject {
    // Store the comics
    @Published var state: ComicsScrollViewState = .idle
    // Track the current ID that we use for adding new comics in the list
    var currentID: Int? = nil
    
    private var searchTask: Task<Void, Never>?
    
    // save favorites
    let storageService: StorageServiceProtocol = StorageService()
    
    private func updateState(_ newState: ComicsScrollViewState) async {
        await MainActor.run {
            self.state = newState
        }
    }
    
    func loadData() async {
        await updateState(.loading)
        await fetchComic(by: nil)
    }

    func fetchNextComic() async {
        currentID = (currentID ?? 0) - 1
        await fetchComic(by: currentID)
    }

    
    func searchComics(query: String) async {
        searchTask?.cancel()
        
        searchTask = Task {
            await updateState(.loading)
            do {
                let comics = try await XKCDSearchService.shared.searchComics(query: "adam")
                
//                if !Task.isCancelled {
                    await updateState(.loaded(comics))
//                }
            } catch {
                await updateState(.error(error.localizedDescription))
            }
        }
    }

    private func fetchComic(by id: Int?) async {
        do {
            let comic = try await XKCDService.shared.fetchComics(id: id)
            if self.currentID == nil {
                self.currentID = comic.num
            }
            if case .loaded(var comics) = state {
                comics.append(comic)
                await updateState(.loaded(comics))
            } else {
                await updateState(.loaded([comic]))
            }
        } catch {
            await updateState(.error(error.localizedDescription))
        }
    }
    
    func getImage(for comicId: Int) -> String {
        storageService.contains(comicId: comicId) ? "heart.fill" : "heart"
    }
}

