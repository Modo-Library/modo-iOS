//
//  BookViewModel.swift
//  Modo
//
//  Created by MacBook on 2023/05/14.
//

import Foundation


class BookViewModel: ObservableObject {
    @Published var books: [Book] = Book.getDummy()
    
}
