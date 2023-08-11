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

final class AddNewCategoryViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .BackGroundDay
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.textColor = .BlackDay
        textField.font = UIFont.ypRegular17()
        // Создаем отступ, для текста в плейсхолдере
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.WhiteDay, for: .normal)
        button.backgroundColor = .BlackDay
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.ypMedium16()
        button.layer.cornerRadius = 16
        button.isEnabled = false
      //  button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: AddNewCategoryViewControllerDelegate?
    private var newCategoryText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .WhiteDay
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(categoryNameTextField)
        view.addSubview(doneButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoryNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
            doneButton.backgroundColor = .BlackDay
        } else {
            doneButton.isUserInteractionEnabled = false
            doneButton.backgroundColor = .Gray
        }
    }
}
// MARK: - UITextFieldDelegate


extension AddNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newCategoryText = textField.text ?? ""
        textField.resignFirstResponder()
        //передать вьюмодели текст 
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            doneButton.backgroundColor = .Gray
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .BlackDay
        }
    }
}


