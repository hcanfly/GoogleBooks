//
//  SearchViewCotroller.swift
//  GoogleBooks
//
//  Created by Gary Hanson on 3/21/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//


import UIKit

final class SearchViewController: UIViewController {
    var coordinator: SearchCoordinator?
    private var tableView: UITableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var books: BookList?
    private let debouncer = Debouncer()
    private var debounceReload: (() -> Void)!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .blue
        self.coordinator = SearchCoordinator(navigationController: self.navigationController!)

        self.tableView.frame = self.view.frame.insetBy(dx: 20, dy: 180)
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = .clear
        self.view.addSubview(self.tableView)

        self.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)

        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Google Books"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.setupConstraints()

        self.debounceReload = self.debouncer.debounce(delay: .seconds(1)) {
            if self.searchController.searchBar.text!.count > 1 {
                // just in case of an extra space. more than that - too bad
                let newstring = self.searchController.searchBar.text!.replacingOccurrences(of: "  ", with: " ")
                var searchString = newstring.replacingOccurrences(of: " ", with: "+")
                searchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                if searchString.count > 1 {
                    self.findMatchingBooks(for: searchString)
                }
            }
        }
    }
    
    private func setupConstraints() {
        let edgeInsets = self.view.safeAreaInsets

        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: edgeInsets.left),
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: edgeInsets.bottom),
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: edgeInsets.right)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchController.searchBar.becomeFirstResponder()
    }

    private func findMatchingBooks(for subject: String) {
        getMatchingBooks(for: subject, myType: BookList.self) { [weak self] foundTitles in
            if let self = self {
                self.books = foundTitles
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}


extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = self.books!.books![indexPath.row]
        self.coordinator?.selected(book: book)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1.336 * (tableView.bounds.width * 0.4)
    }
}

extension SearchViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return self.books == nil ? 0 : self.books!.books!.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier, for: indexPath) as? BookTableViewCell else {
        fatalError("Failed to dequeue a BookTableViewCell")
    }

    if let urlString = self.books!.books![indexPath.row].volumeInfo?.imageLinks?.smallThumbnail {
        cell.cellImageView.downloadImage(urlString: urlString)
        cell.clipsToBounds = true
    }
    cell.titleText = self.books!.books![indexPath.row].volumeInfo?.title
    cell.authorText = self.books!.books![indexPath.row].volumeInfo?.authorString
    cell.descriptionText = self.books!.books![indexPath.row].volumeInfo?.description

    return cell
  }
}

extension SearchViewController: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {
    self.debounceReload()
  }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
}


class Debouncer {

    var currentWorkItem: DispatchWorkItem?

    func debounce(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
        return {  [weak self] in
            guard let self = self else { return }
            self.currentWorkItem?.cancel()
            self.currentWorkItem = DispatchWorkItem { action() }
            queue.asyncAfter(deadline: .now() + delay, execute: self.currentWorkItem!)
        }
    }
}
