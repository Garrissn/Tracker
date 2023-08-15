//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 01.07.2023.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func didNewCategorySelect(categoryTitle: String)
}
private enum AddCategoryLocalize {
    static let addCategoryLabelText = NSLocalizedString("category.title", comment: "Title on navbar category")
    static let placeHolderText = NSLocalizedString("placeholder.emptyCategories.title", comment: "Title on empty categories placeholder")
    static let addCategoryButtonText = NSLocalizedString("button.addCategory.title", comment: "Text on addcategory button")
}

final class AddCategoryViewController: UIViewController {
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AddCategoryLocalize.addCategoryLabelText
        label.textColor = .TrackerBlack
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
        label.text = AddCategoryLocalize.placeHolderText
        label.textColor = .TrackerBlack
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
        button.setTitle(AddCategoryLocalize.addCategoryButtonText, for: .normal)
        button.setTitleColor(.TrackerWhite, for: .normal)
        button.backgroundColor = .TrackerBlack
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.ypMedium16()
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: AddCategoryViewModel
    private var categoryTitle: String
    private var checkFlag: Bool = false
    
    init( viewModel: AddCategoryViewModel, categoryTitle: String) {
        self.categoryTitle = categoryTitle
        self.viewModel = viewModel
        viewModel.loadCategories()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    weak var delegate: AddCategoryViewControllerDelegate?
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .TrackerWhite
        addViews()
        setupConstraints()
        checkPlaceHolder()
    }
    
    func bind() {
        viewModel.$categories.bind { [weak self] _ in
            guard let self = self else { return }
            self.categoryTableView.reloadData()
        }
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
            categoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -39),
            
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
        if checkFlag {
            checkFlag = false
            dismiss(animated: true)
        }
        let model = AddNewCategoryModel()
        let viewModel = AddNewCategoryViewModel(model: model)
        let addNewcategoryViewController = AddNewCategoryViewController(viewModel: viewModel)
        addNewcategoryViewController.delegate = self
        present(addNewcategoryViewController, animated: true)
        
    }
    
    private func checkPlaceHolder() {
        if viewModel.categories.count != 0 {
            placenolderImageView.isHidden = true
            placeHolderTextLabel.isHidden = true
        }
    }
}

extension AddCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.categoryTableViewCellIdentifier) as? CategoryTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.accessoryType = .none
        let cellTitle = viewModel.categories[indexPath.row].title
        cell.configure(cellTitle: cellTitle, isSelected: cellTitle == categoryTitle)
        return cell
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
        let selectedCategory = viewModel.categories[indexPath.row]
        delegate?.didNewCategorySelect(categoryTitle: selectedCategory.title)
       
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

extension AddCategoryViewController: AddNewCategoryViewControllerDelegate {
    func didSelectNewCategory(name: TrackerCategory) {
        //получмлм название категории и через модель записать в контекст
        viewModel.addNewCategory(category: name)
        categoryTableView.reloadData()
        checkPlaceHolder()
        //проверка вьюмодели трекер категории пуст -Ю кнопка неактивна
    }
}
