//
//  AddNewTracker.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.06.2023.
//

import UIKit

protocol AddscheduleViewControllerDelegate: AnyObject {
    func didSelectScheduleValue( _ value: String)
    func didSelectCategoryValue(_ vulue: String)
}
final class AddNewTrackerViewController: UIViewController {
    
   private let habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .BackGroundDay
        textField.layer.cornerRadius = 16
       
       let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.gray]
       let attributedPlaceHolder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
       textField.attributedPlaceholder = attributedPlaceHolder
       textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
       textField.textColor = .Gray
       textField.font = UIFont(name: "SP-Pro", size: 17)
//        textField.delegate = self
        return textField
    }()
    
   private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
       // collectionView.register(<#T##nib: UINib?##UINib?#>, forCellWithReuseIdentifier: <#T##String#>)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
         
         return collectionView
     }()
    private let cancellButton: UIButton = {
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle("Отменить", for: .normal)
         button.titleLabel?.font = UIFont(name: "SP-Pro", size: 16)
         button.tintColor = .Red
         button.layer.cornerRadius = 16
         return button
     }()
    private let createButton: UIButton = {
         let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont(name: "SP-Pro", size: 16)
        button.tintColor = .WhiteDay
        button.layer.cornerRadius = 16
        button.backgroundColor = .Gray
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
         return button
     }()
    
    private let labelArray: [String] = ["Категория", "Расписание"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
        tableView.register(AddNewTrackerTableViewCell.self, forCellReuseIdentifier: AddNewTrackerTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.textColor = .BlackDay
        titleLabel.font = UIFont(name: "SFProText-Medium", size: 16)
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        
    }
    private func setupViews() {
        view.addSubview(habitNameTextField)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(cancellButton)
        view.addSubview(createButton)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            habitNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 204),
            
            cancellButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cancellButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancellButton.heightAnchor.constraint(equalToConstant: 60),
            cancellButton.widthAnchor.constraint(equalToConstant: 166),
            
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            
            
        ])
        
    }
    @objc private func createButtonTapped() {
        //обновили таблицу вернулись в мейн
    }
}
extension AddNewTrackerViewController : AddscheduleViewControllerDelegate {
    func didSelectCategoryValue(_ vulue: String) {
        // сохранить категорию в дескрипш лейбл таблицы
    }
    
    func didSelectScheduleValue(_ value: String) {
        //сохранить день недели в таблицу
    }
    
    
    
    
}
extension AddNewTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return updatedText.count <= 38
    }
    
   //
}
extension AddNewTrackerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: AddNewTrackerTableViewCell.reuseIdentifier, for: indexPath)
        guard let addNewTrackerTableViewCell = cell as? AddNewTrackerTableViewCell else { return UITableViewCell()}
        
        cell.textLabel?.text = labelArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let addCategoryViewController = AddCategoryViewController()
           // addCategoryViewController.delegate = self
            
            let navVC = UINavigationController(rootViewController: addCategoryViewController)
            present(navVC, animated: true)
        }
        else if indexPath.row == 1 {
            let addScheduleViewController = AddScheduleViewController()
            addScheduleViewController.delegate = self
            
            let navVc = UINavigationController(rootViewController: addScheduleViewController)
            present(navVc, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 75
    }
    
}
