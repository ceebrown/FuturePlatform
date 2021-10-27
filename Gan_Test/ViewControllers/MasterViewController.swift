//
//  MainController.swift
//  Gan_Test
//
//  Created by Clive Brown on 09/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
    
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private let cellIdentifier = "SearchViewCell"
    private var appearances: [String] = []
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
  
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchViewController()
        setupNavBar()
        setupKeyboardNotifications()
        getCharacters()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
  
    // MARK: - Setup Search Controller
    
    private func setupSearchViewController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup Navigation Controller
    private func setupNavBar(){
        self.title = "Breaking Bad Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        adjustLargeTitleSize()
    }
    
    private func setupKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                   object: nil, queue: .main) { (notification) in
                                    self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                   object: nil, queue: .main) { (notification) in
                                    self.handleKeyboard(notification: notification) }
    }
    
    private func updateScopeButtonTiles(appearances: [String]?) {
        searchController.searchBar.scopeButtonTitles = appearances
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        guard segue.identifier == "ShowDetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController else {
            return
        }

        let character: Character
        if isFiltering {
            character = filteredCharacters[indexPath.row]
        } else {
            character = characters[indexPath.row]
        }
        detailViewController.character = character
   
    }

    func filterContentForSearchText(_ searchText: String, appearance: String? = nil) {
        filteredCharacters = characters.filter { (character: Character) -> Bool in

            let doesAppearanceMatch = appearance == "All" || (character.appearance?.map(String.init).filter{$0 == appearance})?.first == appearance
            if isSearchBarEmpty {
                return doesAppearanceMatch
            } else {
                return doesAppearanceMatch && character.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
  
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }

        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCharacters.count, of: characters.count)
            return filteredCharacters.count
        }

        searchFooter.setNotFiltering()
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCell", for: indexPath) as! MasterCell
        let character: Character
        if isFiltering {
            character = filteredCharacters[indexPath.row]
        } else {
            character = characters[indexPath.row]
        }
        cell.configure(character: character)

        return cell
    }
    
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let appearance = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, appearance: appearance)
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let appearance = searchBar.scopeButtonTitles![selectedScope]
        filterContentForSearchText(searchBar.text!, appearance: appearance)
    }
}

extension MasterViewController {
    // MARK: - Network Service
    
    private func getCharacters() {
        let networkService = NetworkManager()
        networkService.getCharacters() { [weak self] result in

            switch result {
            case .success(let characters):
                self?.characters = characters

                let app = characters.map({$0.appearance})
                let reduced = app.compactMap{$0}.flatMap{$0}

                let uniqueArray = reduced.unique()
                self?.appearances = uniqueArray.map(String.init)
   
                self?.appearances.insert("All", at: 0)
                self?.updateScopeButtonTiles(appearances: self?.appearances)
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

