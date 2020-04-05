//
//  Model.swift
//  GoogleBooks
//
//  Created by Gary Hanson on 3/19/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


struct Book: Decodable {
    let id: String?
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Decodable {
    let title: String?
    let authors: [String]?
    let description: String?
    let previewLink: String?
    let imageLinks: ImageLink?
    let publisher: String?
    let publishedDate: String?

    var authorString: String {
        var authorString = ""
        if let authors = self.authors {
            for a in authors {
                authorString += "\(a), "
            }
            authorString.removeLast(2)
        }
        return authorString
    }
}

struct ImageLink: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct BookList: Decodable {
    let books: [Book]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

extension BookList {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        books = try? values.decode([Book].self, forKey: .items)
    }
}
