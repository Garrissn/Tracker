//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 01.07.2023.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func didNewCategoryselect(category: TrackerCategory)
}

final class AddCategoryViewController: UIViewController {
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var placenolderImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "error")
        imageView.image = image
        imageView.isHidden = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeHolderTextLabel: UILabel = {
        let label = UILabel ()
        label.text = "Привычки и события можно объединить по смыслу"
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium12()
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.categoryTableViewCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.WhiteDay, for: .normal)
        button.backgroundColor = .BlackDay
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.ypMedium16()
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
 //   weak var delegate: CategoriesListViewControllerDelegate?
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //загрузить из кордаты названия категорий
        view.backgroundColor = .WhiteDay
        addViews()
        setupConstraints()
        checkPlaceHolder()
    }
    // MARK: - Private Methods
    
    private func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(categoryTableView)
        view.addSubview(placenolderImageView)
        view.addSubview(placeHolderTextLabel)
        view.addSubview(addCategoryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: 39),
            
            placenolderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placenolderImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            placenolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placenolderImageView.widthAnchor.constraint(equalToConstant: 80),
            
            placeHolderTextLabel.topAnchor.constraint(equalTo: placenolderImageView.bottomAnchor, constant: 8),
            placeHolderTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.widthAnchor.constraint(equalToConstant: 335),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
    }
    
    @objc private func addCategoryButtonTapped() {
        
        let categoriesViewController = AddNewCategoryViewController()
        //addNewTrackerViewController.trackerType = .habitTracker
        //addNewTrackerViewController.delegate = self
        present(categoriesViewController, animated: true)
        
    }
    
    private func checkPlaceHolder() {
        
        placenolderImageView.isHidden = true
        placeHolderTextLabel.isHidden = true
    }
}

extension AddCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return
    }
    
    
}

extension AddCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        SeparatorLineHelper.configSeparatingLine(tableView: tableView, cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AddCategoryViewController: AddNewCategoryViewControllerDelegate {
    func didSelectNewCategory(name: TrackerCategory) {
        //получмлм название категории и через модель записать в контекст
        categoryTableView.reloadData()
        //проверка вьюмодели трекер категории пуст -Ю кнопка неактивна
    }
    
    
}
