//
//  AddNewTracker.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.06.2023.
//

import UIKit

protocol AddNewTrackerViewControllerDelegate: AnyObject {
    func didSelectNewTracker(newTracker: TrackerCategory)
}

final class AddNewTrackerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        switch trackerType {
        case .none:
            break
        case .habitTracker: label.text = "Новая привычка"
        case .irregularIvent: label.text = "Новое нерегулярное событие"
        }
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
        let leftInsertView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 30))
        textField.leftView = leftInsertView
        textField.leftViewMode = .always
        textField.textColor = .BlackDay
        textField.font = UIFont.ypRegular17()
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.delegate = self
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    
    private var currentCatergory: String? = "Новая категория"
    private var schedule: [WeekDay] = []
    private var newTrackerText: String = ""
    private var heightTableView: CGFloat = 74
    
    weak var delegate: AddNewTrackerViewControllerDelegate?
    var trackerType: TrackerType?
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(habitNameTextField)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(cancellButton)
        view.addSubview(createButton)
    }
    private func setupConstraints() {
        switch trackerType {
        case .habitTracker: heightTableView = 174
        case .irregularIvent: heightTableView = 75
        case.none: break
        }
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            habitNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            habitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: heightTableView),
            
            //            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            //            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            //            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            //            collectionView.heightAnchor.constraint(equalToConstant: 204),
            
            cancellButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancellButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancellButton.heightAnchor.constraint(equalToConstant: 60),
            cancellButton.widthAnchor.constraint(equalToConstant: 166),
            cancellButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
    @objc private func createButtonTapped() {
        let trackerTitleName = habitNameTextField.text ?? ""
        self.delegate?.didSelectNewTracker(newTracker: TrackerCategory(title: "Новая Категория",
                                                                       trackers: [Tracker.init(id: UUID(),
                                                                                               title: trackerTitleName,
                                                                                               color: .ColorSelection2,
                                                                                               emoji: "😻", schedule: self.schedule)]))
        
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func createButtonIsEnabled() {
        if habitNameTextField.text?.isEmpty == false && (currentCatergory?.isEmpty != nil ) {
            createButton.backgroundColor = .BlackDay
            createButton.setTitleColor(.WhiteDay, for: .normal)
            createButton.isEnabled = true
        }
    }
}

// MARK: - AddscheduleViewControllerDelegate

extension AddNewTrackerViewController : AddscheduleViewControllerDelegate {
    func didSelectScheduleValue(_ value: [WeekDay]) {
        self.schedule = value
        print(" schedule :\(schedule)")
        tableView.reloadData()
        createButtonIsEnabled()
    }
}

// MARK: - UITextFieldDelegate

extension AddNewTrackerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newTrackerText = textField.text ?? ""
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            createButton.backgroundColor = .Gray
            createButton.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //   guard let currentText = textField.text else { return true }
        if range.location == 0 &&  string == " " { return false }
        switch trackerType {
        case .habitTracker:
            if schedule.isEmpty == false {
                createButtonIsEnabled()
                return true
            }
        case .irregularIvent:
            createButtonIsEnabled()
            return true
        case .none:
            return true
        }
        return true
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension AddNewTrackerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trackerType {
        case .habitTracker: return 2
        case .irregularIvent: return 1
        case .none: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let scheduleShortValueText = schedule.map { $0.shortValue }.joined(separator: ",")
            cell.detailTextLabel?.text = scheduleShortValueText
            
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




