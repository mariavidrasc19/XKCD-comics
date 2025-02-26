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
    @Published var searchResults: [Int] = []
    @Published var searchComics: [Comic] = []
    
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
    
    func loadData() async throws {
        await updateState(.loading)
        try await fetchComic(by: nil)
    }

    func fetchNextComic() async throws {
        currentID = (currentID ?? 0) - 1
        try await fetchComic(by: currentID)
    }

    
    func searchComics(query: String) async {
        searchTask?.cancel()
        
        searchTask = Task {
            await updateState(.loading)
            do {
                let comicIds = try await XKCDSearchService.shared.searchComics(query: query)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.searchResults = comicIds
                        self.searchComics = []
                        self.state = .loaded([])
                    }

                    // add founded comics
                    await withTaskGroup(of: Void.self) { group in
                        // keep track of the groups that are busy
                        var activeTasks = 0
                        
                        for comicId in comicIds {
                            if activeTasks >= 4 {
                                await group.next()
                                // after a group is finished make it available for the next tasks
                                activeTasks -= 1
                            }
                            
                            // 'charging' the group with tasks
                            group.addTask {
                                do {
                                    try await self.fetchComic(by: comicId, isSearchResult: true)
                                } catch {
                                    print("Error loading comic \(comicId): \(error)")
                                }
                            }
                            activeTasks += 1
                        }
                    }
               }
            } catch {
                await updateState(.error(error.localizedDescription))
            }
        }
    }

    func fetchComic(by id: Int?, isSearchResult: Bool = false) async throws {
        let comic = try await XKCDService.shared.fetchComics(id: id)
        if self.currentID == nil {
            self.currentID = comic.num
        }

        if isSearchResult {
            await MainActor.run {
                self.searchComics.append(comic)
            }
        } else {
            if case .loaded(var comics) = state {
                comics.append(comic)
                await updateState(.loaded(comics))
            } else {
                await updateState(.loaded([comic]))
            }
        }
    }
    
    func getImage(for comicId: Int) -> String {
        storageService.contains(comicId: comicId) ? "heart.fill" : "heart"
    }
}

