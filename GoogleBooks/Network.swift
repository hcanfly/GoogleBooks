//
//  Network.swift
//  GoogleBooks
//
//  Created by Gary on 4/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation


let baseURLString = "https://www.googleapis.com/books/v1/volumes?q="



private func fetchNetworkData<T: Decodable>(url: URL?, myType: T.Type, completion: @escaping (T) -> Void) {
    guard let url = url else {
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


func getMatchingBooks<T: Decodable>(likeTitle title: String, myType: T.Type, completion: @escaping (T) -> Void) {

    fetchNetworkData(url: .matchingBooks(likeTitle: title), myType: T.self) { foundBooks in
         completion(foundBooks)
     }
}

extension URL {

    fileprivate static func matchingBooks(likeTitle title: String) -> URL? {
        URL(string: baseURLString + "\(title)")
    }

}
