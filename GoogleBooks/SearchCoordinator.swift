//
//  SearchCoordinator.swift
//  GoogleBooks
//
//  Created by Gary on 3/3/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit



final class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController


    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func selected(book: Book) {
        let webVC = WebViewController.instantiate()
        if let linkString = book.volumeInfo?.previewLink {
            webVC.urlString = linkString
        }

        self.navigationController.pushViewController(webVC, animated: false)
    }
}
