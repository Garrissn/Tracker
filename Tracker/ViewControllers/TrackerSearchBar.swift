//
//  TrackerSearchBar.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.08.2023.
//

import UIKit

// MARK: - SearchBar class

final class TrackerSearchBar: UISearchBar {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // self.backgroundColor = .BackGroundDay
        self.layer.cornerRadius = 16
        self.searchTextField.textColor = .TrackerBlack
        //self.searchTextField.font = UIFont.ypRegular17()
        self.searchBarStyle = .minimal
        self.returnKeyType = .go
        self.searchTextField.clearButtonMode = .never
        self.placeholder = NSLocalizedString(
            "searchBar.placeholder.title",
            comment: "Title of the placeHolder on searchbar"
        )
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
