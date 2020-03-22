//
//  Model.swift
//  GoogleBooks
//
//  Created by Gary Hanson on 3/19/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit

let baseURLString = "https://www.googleapis.com/books/v1/volumes?q="


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
        for i in self.authors! {
            authorString += "\(i), "
        }
        authorString.removeLast(2)
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



private func fetchNetworkData<T: Decodable>(urlString: String, myType: T.Type, completion: @escaping (T) -> Void) {
      guard let url = URL(string: urlString) else {
        return
      }
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let data = data {
            //let str = String(decoding: data, as: UTF8.self)
            //print(str)
            let jsonDecoder = JSONDecoder()
            do {
                let theData = try jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(theData)
                }
            } catch {
                print("Error parsing JSON")
            }
        } else {
            print("Download error: " + error!.localizedDescription)
        }
    }

    task.resume()
}

func getMatchingBooks<T: Decodable>(for subject: String, myType: T.Type, completion: @escaping (T) -> Void) {

    fetchNetworkData(urlString: baseURLString + "\(subject)", myType: T.self) { foundBooks in
         completion(foundBooks)
     }
}
