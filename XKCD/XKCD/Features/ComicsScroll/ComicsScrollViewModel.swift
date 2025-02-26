//
//  ComicsCarouselViewModel.swift
//  XKCD
//
//  Created by Maria Vidrasc on 22.02.2025.
//

import Foundation


// structure that stores the state of the screen
enum ComicsScrollViewState {
    case idle
    case loading
    case loaded([Comic])
    case searchResults([Comic])
    case favorites([Comic])
    case error(String)
}

@MainActor
class ComicsScrollViewModel: ObservableObject {
    // Store the comics
    @Published var state: ComicsScrollViewState = .idle
    @Published var searchResults: [Int] = []
    
    // Track the current ID that we use for adding new comics in the list
    var currentID: Int? = nil
    
    private var searchTask: Task<Void, Never>?
    
    private func updateState(_ newState: ComicsScrollViewState) async {
        await MainActor.run {
            self.state = newState
        }
    }
    
    func loadData() async throws {
        await updateState(.loading)
        let comic = try await fetchComic(by: nil)
        self.currentID = comic.id
        await updateState(.loaded([comic]))
    }

    func fetchNextComic() async throws {
        currentID = (currentID ?? 0) - 1
        let comic = try await fetchComic(by: currentID)
        if case .loaded(var comics) = state {
            comics.append(comic)
            await updateState(.loaded(comics))
        }
    }
    
    func getFavorites() async {
        await updateState(.loading)
        let comics = StorageService.shared.getComics()
        await updateState(.favorites(comics))
    }
    
    func getBrowsing() async throws {
        await updateState(.loading)
        try await loadData()
    }

    func searchComics(query: String) async {
        searchTask?.cancel()
        
        searchTask = Task {
            await updateState(.loading)
            do {
                let comicIds = try await XKCDSearchService.shared.searchComics(query: query)
                if !Task.isCancelled {
                    if comicIds.isEmpty {
                        await self.updateState(.error("No data found for query \(query)"))
                        return
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
                                    let comic = try await self.fetchComic(by: comicId, isSearchResult: true)
                                    if case .searchResults(var comics) = await self.state {
                                        comics.append(comic)
                                        await self.updateState(.searchResults(comics))
                                    } else {
                                        await self.updateState(.searchResults([comic]))
                                    }
                                } catch {
                                    await self.updateState(.error("Error loading comic \(comicId): \(error)"))
                                    
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

    func fetchComic(by id: Int?, isSearchResult: Bool = false) async throws -> Comic {
        let comic = try await XKCDService.shared.fetchComics(id: id)
        return comic
    }
    
    func toggleFavorite(for comic: Comic) async {
        if StorageService.shared.contains(comicId: comic.id) {
            StorageService.shared.delete(comicId: comic.id)
        } else {
            StorageService.shared.save(comic: comic)
        }
    }
    
    func getImage(for comicId: Int) -> String {
        StorageService.shared.contains(comicId: comicId) ? "heart.fill" : "heart"
    }
}

