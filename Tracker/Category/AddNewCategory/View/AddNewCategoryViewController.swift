//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 09.08.2023.
//

import UIKit

protocol AddNewCategoryViewControllerDelegate: AnyObject {
    func didSelectNewCategory(name: TrackerCategory)
}
private enum AddNewCategoryLocalize {
    static let addNewCategoryLabelText = NSLocalizedString("newCategory.title", comment: "Title on navbar new category")
    static let textFieldPlaceHolderText = NSLocalizedString("textField.category.title", comment: "Text on textfieldPlaceHolder")
    }
final class AddNewCategoryViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AddNewCategoryLocalize.addNewCategoryLabelText
        label.textColor = .TrackerBlack
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .TrackerBackGround
        textField.placeholder = AddNewCategoryLocalize.textFieldPlaceHolderText
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.textColor = .Gray
        textField.font = UIFont.ypRegular17()
        // Создаем отступ, для текста в плейсхолдере
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.TrackerWhite, for: .normal)
        button.backgroundColor = .Gray
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.ypMedium16()
        button.layer.cornerRadius = 16
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: AddNewCategoryViewControllerDelegate?
    private var newCategoryText: String = ""
    private let viewModel: AddNewCategoryViewModel
    
    init(viewModel: AddNewCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .TrackerWhite
        addTableViews()
        setupTableConstraints()
    }
    
    func bind() {
        viewModel.$isCategoryTitleFilled.bind { [weak self] isFilled in
            guard let self = self else { return }
            updateDoneButton(isActive: isFilled)
        }
    }
    
    private func addTableViews() {
        view.addSubview(titleLabel)
        view.addSubview(categoryNameTextField)
        view.addSubview(doneButton)
    }
    
    private func  setupTableConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func doneButtonTapped() {
        let trackerCategoryName = categoryNameTextField.text ?? ""
        let trackerCategory = TrackerCategory(title: trackerCategoryName, trackers: [])
        self.delegate?.didSelectNewCategory(name: trackerCategory )
        dismiss(animated: true)
    }
    
    private func updateDoneButton(isActive: Bool) {
        if isActive {
            doneButton.isUserInteractionEnabled = true
            doneButton.backgroundColor = .TrackerBlack
        } else {
            doneButton.isUserInteractionEnabled = false
            doneButton.backgroundColor = .Gray
        }
    }
}
// MARK: - UITextFieldDelegate
extension AddNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        newCategoryText = textField.text ?? ""
        //передать вьюмодели текст
        viewModel.checkCategoryTitle(text: textField.text)
        return true
    }
}


