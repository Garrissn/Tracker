//
//  AddScheduleViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 30.06.2023.
//


import UIKit

protocol AddscheduleViewControllerDelegate: AnyObject {
    func didSelectScheduleValue( _ value: [WeekDay])
}

final class AddScheduleViewController: UIViewController {
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "shceduleCell")
        tableView.layer.cornerRadius = 16
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.ScheduleTableViewCellIdentifier)
        tableView.separatorColor = .Gray
        tableView.backgroundColor = .WhiteDay
        
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name: "SP-Pro", size: 16)
        button.tintColor = .WhiteDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .Gray
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var selectedDays: [WeekDay] = []
    private var allDay = WeekDay.allCases
    weak var delegate: AddscheduleViewControllerDelegate?
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func doneButtonTapped() {
        self.delegate?.didSelectScheduleValue(self.selectedDays)
        dismiss(animated: true)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            selectedDays.append(allDay[sender.tag])
            print(allDay[sender.tag])
        } else {
            if let index = selectedDays.firstIndex(of: allDay[sender.tag]) {
                selectedDays.remove(at: index)
            }
        }
        doneButtonEnabled(!selectedDays.isEmpty)
    }
    
    private func doneButtonEnabled(_ isOn: Bool) {
        if isOn {
            doneButton.isEnabled = isOn
            doneButton.backgroundColor = .BlackDay
            doneButton.setTitleColor(.WhiteDay, for: .normal)
        } else {
            doneButton.backgroundColor = .Gray
            doneButton.setTitleColor(.WhiteDay, for: .normal)
        }
    }
}

// MARK: - UITableViewDataSource

extension AddScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let daySwitcher = UISwitch()
        daySwitcher.onTintColor = .Blue
        daySwitcher.tag = indexPath.row
        daySwitcher.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
      guard  let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.ScheduleTableViewCellIdentifier) as? ScheduleTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.backgroundColor = .BackGroundDay
        cell.textLabel?.font = .ypRegular17()
        let textLabel = allDay[indexPath.row].stringValue
        cell.configureScheduleTableCell(cellTitle: textLabel)
        cell.accessoryView = daySwitcher
        return cell
    }
}
// MARK: - UITableViewDelegate

extension AddScheduleViewController: UITableViewDelegate {  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        SeparatorLineHelper.configSeparatingLine(tableView: tableView, cell: cell, indexPath: indexPath)
    }
}
