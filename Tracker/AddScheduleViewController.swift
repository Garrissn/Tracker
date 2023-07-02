//
//  AddScheduleViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 30.06.2023.
//


import UIKit

final class AddScheduleViewController: UIViewController {
    
    private let tableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false
         
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
         return button
     }()
    
    weak var delegate: AddscheduleViewControllerDelegate?
    private var scheduleWeekDays: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", " Пятница", "Суббота", "Воскресенье"]
    private var selectedDays: [WeekDay] = []
    var selectedDaysString: String = ""
    private let allDays: [WeekDay] = [.monday,.tuesday,.wednesday,.thursday,.friday,.saturday,.sunday]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
        tableView.register(AddScheduleTableViewCell.self, forCellReuseIdentifier: AddScheduleTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Расписание"
        titleLabel.textColor = .BlackDay
        titleLabel.font = UIFont(name: "SFProText-Medium", size: 16)
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        
    }
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
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
        
        if selectedDays.count == allDays.count {
            selectedDaysString = "Каждый день"
        } else if selectedDays.isEmpty {
            selectedDaysString = "Нет выбранных дней"
        } else {
            let sortedDays = selectedDays.sorted {$0.numberValue < $1.numberValue}
            selectedDaysString = sortedDays.map { $0.stringValue }.joined(separator: ",")
        }
        delegate?.didSelectScheduleValue(selectedDaysString)
        let addNewTrackerViewController = AddNewTrackerViewController()
        let navVC = UINavigationController(rootViewController: addNewTrackerViewController)
        present(navVC, animated: true)
        
//        addScheduleViewController.delegate = self
//
//        delegate?.didSelectScheduleValue(T##value: String##String)
//        navigationController?.pop
    }
    @objc private func switchValueChanged(sender: UISwitch) {
        guard let cell = sender.superview?.superview as? AddScheduleTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        let day = allDays[indexPath.row]
        if sender.isOn {
            selectedDays.append(day)
        } else {
            if let index = selectedDays.firstIndex(of: day) {
                selectedDays.remove(at: index)
            }
        }
        
    }
}

extension AddScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleWeekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddScheduleTableViewCell.reuseIdentifier, for: indexPath)
        guard let addScheduleTableViewCell = cell as? AddScheduleTableViewCell else { return UITableViewCell() }
        let day = allDays[indexPath.row]
        addScheduleTableViewCell.schDaysLabel.text = scheduleWeekDays[indexPath.row]
        addScheduleTableViewCell.daySwitch.isOn = selectedDays.contains(day)
        addScheduleTableViewCell.daySwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        return addScheduleTableViewCell
    }
    
    
}
extension AddScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? AddScheduleTableViewCell else { return }
        cell.daySwitch.setOn(!cell.daySwitch.isOn, animated: true)
        switchValueChanged(sender: cell.daySwitch)
       //cell.daySwitch.addTarget(self, action: #selector(switchValueChanged()), for: .valueChanged)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
