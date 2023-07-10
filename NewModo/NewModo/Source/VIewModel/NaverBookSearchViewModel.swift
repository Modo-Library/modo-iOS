//
//  NaverBookSearchViewModel.swift
//  Modo
//
//  Created by MacBook on 2023/05/23.
//

import Foundation
import Combine

final class NaverBookViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    //@Published var bookSearchResult: NaverBookSearch = NaverBookSearch(lastBuildDate: "", total: 0,start: 0, display: 0, items: [])
    @Published var searchResultBooks : [BookInfo] = []
    @Published var state : String = "불러오는중"
    
    var fetchNaverBookSearchSuccess = PassthroughSubject<(), Never>()
    var insertNaverBookSearcheSuccess = PassthroughSubject<(), Never>()
    
    func fetchNaverBookSearch(bookName: String) {
        NaverBookSearchService.getNaverBookSearch(bookName: bookName)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    // 오류 처리
                    self.state = "불러오기 실패"
                    print("Error:", error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (data: NaverBookSearch) in
                guard let self = self else { return }
                print("receiveValue")
                self.searchResultBooks = []
                for book in data.items {
                    self.searchResultBooks.append(book)
                    print(book.title)
                }
                self.fetchNaverBookSearchSuccess.send()
            }.store(in: &subscription)
        print("fetchNaverBookSearchResult")
    }
}
