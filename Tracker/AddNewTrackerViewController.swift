//
//  AddNewTracker.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.06.2023.
//

import UIKit


final class AddNewTrackerViewController: UIViewController {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
   private lazy var habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .BackGroundDay
        textField.layer.cornerRadius = 16
       
       let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.gray]
       let attributedPlaceHolder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
       textField.attributedPlaceholder = attributedPlaceHolder
       textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
       textField.textColor = .Gray
       textField.font = UIFont.ypRegular17()
       textField.layer.cornerRadius = 16
       textField.clipsToBounds = true
       //textField.delegate = self
        return textField
    }()
    
   private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = .BackGroundDay
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.separatorColor = .Gray
       
        return tableView
    }()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
       // collectionView.register(<#T##nib: UINib?##UINib?#>, forCellWithReuseIdentifier: <#T##String#>)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
         
         return collectionView
     }()
    private lazy var cancellButton: UIButton = {
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle("Отменить", for: .normal)
         button.setTitleColor(.Red, for: .normal)
         button.titleLabel?.font = UIFont.ypMedium16()
         button.tintColor = .Red
         button.backgroundColor = .WhiteDay
         button.layer.borderColor = UIColor.Red.cgColor
         button.layer.borderWidth = 1
         button.layer.cornerRadius = 16
         button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
         return button
     }()
    private lazy var createButton: UIButton = {
         let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.setTitleColor(.WhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .Gray
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        
         return button
     }()
    
    private let labelArray: [String] = ["Категория", "Расписание"]
    private var currentCatergory: String = "Новая категория"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupNavigationBar()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
      //  tableView.register(AddNewTrackerTableViewCell.self, forCellReuseIdentifier: AddNewTrackerTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
//    private func setupNavigationBar() {
//        let titleLabel = UILabel()
//        titleLabel.text = "Новая привычка"
//        titleLabel.textColor = .BlackDay
//        titleLabel.font = UIFont.ypMedium16()
//        titleLabel.textAlignment = .center
//
//        navigationItem.titleView = titleLabel
        
    //}
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(habitNameTextField)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(cancellButton)
        view.addSubview(createButton)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            habitNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            habitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
//            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            collectionView.heightAnchor.constraint(equalToConstant: 204),
            
            cancellButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancellButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancellButton.heightAnchor.constraint(equalToConstant: 60),
            cancellButton.widthAnchor.constraint(equalToConstant: 166),
            
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            
            
        ])
        
    }
    @objc private func createButtonTapped() {
        //обновили таблицу вернулись в мейн
    }
    @objc private func cancelButtonTapped() {
       dismiss(animated: true)
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
    
   
}


extension AddNewTrackerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
//        let cell = tableView.dequeueReusableCell(withIdentifier: AddNewTrackerTableViewCell.reuseIdentifier, for: indexPath)
//        guard let addNewTrackerTableViewCell = cell as? AddNewTrackerTableViewCell else { return UITableViewCell()}
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.detailTextLabel?.font = UIFont.ypRegular17()
        cell.detailTextLabel?.textColor = .Gray
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = currentCatergory
        case 1:
            cell.textLabel?.text = "Расписание"
        default: break
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let addCategoryViewController = AddCategoryViewController()
            present(addCategoryViewController, animated: true)
        case 1:
            let addScheduleViewController = AddScheduleViewController()
            addScheduleViewController.delegate = self
            
            present(addScheduleViewController, animated: true)
        default: break
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 75
    }
    
}




