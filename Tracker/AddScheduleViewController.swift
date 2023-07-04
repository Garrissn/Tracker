//
//  AddScheduleViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 30.06.2023.
//


import UIKit

protocol AddscheduleViewControllerDelegate: AnyObject {
    func didSelectScheduleValue( _ value: String)
    func didSelectCategoryValue(_ vulue: String)
}

final class AddScheduleViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "shceduleCell")
         tableView.layer.cornerRadius = 16
         tableView.clipsToBounds = true
         tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
         tableView.separatorColor = .Gray
         tableView.backgroundColor = .WhiteDay
         tableView.isScrollEnabled = false
        
        
         return tableView
    }()
    private let doneButton: UIButton = {
         let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name: "SP-Pro", size: 16)
        button.tintColor = .WhiteDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .BlackDay
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
     }()
    
    weak var delegate: AddscheduleViewControllerDelegate?
   
    private var selectedDays: [WeekDay] = []
    private var allDay = WeekDay.allCases
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setupNavigationBar()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
//        tableView.register(AddScheduleTableViewCell.self, forCellReuseIdentifier: AddScheduleTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
//    private func setupNavigationBar() {
//        let titleLabel = UILabel()
//        titleLabel.text = "Расписание"
//        titleLabel.textColor = .BlackDay
//        titleLabel.font = UIFont(name: "SFProText-Medium", size: 16)
//        titleLabel.textAlignment = .center
//
//        navigationItem.titleView = titleLabel
//
//    }
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 39),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
           // doneButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    @objc private func doneButtonTapped() {
        
        
        let addNewTrackerViewController  = AddNewTrackerViewController()
        let navVC = UINavigationController(rootViewController: addNewTrackerViewController)
        present(navVC, animated: true)
    }
    
}

extension AddScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let daySwitcher = UISwitch()
        daySwitcher.onTintColor = .Blue
        daySwitcher.tag = indexPath.row
        daySwitcher.addTarget(self, action: #selector(doneButtonTapped), for: .valueChanged)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "shceduleCell")
        cell.selectionStyle = .none
        cell.backgroundColor = .BackGroundDay
        cell.textLabel?.font = .ypRegular17()
        cell.textLabel?.text = allDay[indexPath.row].stringValue
        cell.accessoryView = daySwitcher
        
        
        return cell
    }
    
    
}
extension AddScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
extension AddScheduleViewController: AddScheduleTableViewCellDelegate {
    func switchWeekDay(sender: UISwitch) {
        
    }
    
    
    
    
}
