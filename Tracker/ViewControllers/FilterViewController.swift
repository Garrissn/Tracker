//
//  FilterViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 24.08.2023.
//

import UIKit
final class FilterViewController: UIViewController {
    private let filters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var checkFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupViews()
        configureTableView()
    }
    
    private func setupViews() {
        view.addSubview(pageTitleLabel)
        view.addSubview(filtersTableView)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            filtersTableView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 38),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.heightAnchor.constraint(equalToConstant: CGFloat(filters.count * 75))
        ])
    }
    
    private func configureTableView() {
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        filtersTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.categoryTableViewCellIdentifier)
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.categoryTableViewCellIdentifier, for: indexPath) as?
                CategoryTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .TrackerBackGround
        cell.accessoryType = .none
        cell.configure(cellTitle: filters[indexPath.row], isSelected: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        SeparatorLineHelper.configSeparatingLine(tableView: tableView, cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let previousCell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell
        previousCell?.categoryIsSelected(true)
        checkFlag = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let previousCell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell
        previousCell?.categoryIsSelected(false)
        checkFlag = false
    }
}
