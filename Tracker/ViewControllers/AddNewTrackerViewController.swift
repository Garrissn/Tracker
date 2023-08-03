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
        //tableView.separatorStyle = .non
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.separatorColor = .Gray
        return tableView
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private  lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
       // scrollView.contentSize = contentSize
       // scrollView.frame = view.bounds
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
       // contentView.frame.size = contentSize
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
//    private var contentSize: CGSize {
//        CGSize(width: view.frame.width, height: view.frame.height + 400)
//    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AddNewTrackerEmojiesViewCell.self, forCellWithReuseIdentifier: AddNewTrackerEmojiesViewCell.addNewTrackerEmojiesViewCellIdentifier)
        collectionView.register(AddNewTrackerColorViewCell.self, forCellWithReuseIdentifier: AddNewTrackerColorViewCell.addNewTrackerColorViewCellIdentifier)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.headerIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    
    private var selectedEmojiIndexPath: IndexPath?
    
   
    private var selectedColorIndexPath: IndexPath?
    
    private var newTrackerText: String = ""
    private var heightTableView: CGFloat = 75

    
    
    private let emojiesAndColors: EmojiesAndColors = EmojiesAndColors()
    
    
    weak var delegate: AddNewTrackerViewControllerDelegate?
    var trackerType: TrackerType?
    private let paramsForAddNewTrackerCell = GeometricParams(cellCount:6,
                                                             leftInset: 0, rightInset: 0, cellSpacing: 5)
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .WhiteDay
        collectionView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(conteinerView)
       
        
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(habitNameTextField)
        conteinerView.addSubview(tableView)
        conteinerView.addSubview(collectionView)
        conteinerView.addSubview(cancellButton)
        conteinerView.addSubview(createButton)

    }
    private func setupConstraints() {
        switch trackerType {
        case .habitTracker: heightTableView = 150
        case .irregularIvent: heightTableView = 75
        case.none: break
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            

            
            conteinerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            conteinerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            conteinerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            conteinerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            
            titleLabel.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 20),
            
           
            
            habitNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            habitNameTextField.leadingAnchor.constraint(equalTo:conteinerView.leadingAnchor, constant: 16),
            habitNameTextField.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -16),
            habitNameTextField.heightAnchor.constraint(equalToConstant: 75),
           
            
            tableView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: heightTableView),
            
           
                       
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 492),
          
            
            cancellButton.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 20),
            cancellButton.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor),
            cancellButton.heightAnchor.constraint(equalToConstant: 60),
            cancellButton.widthAnchor.constraint(equalToConstant: 166),
            cancellButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancellButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
    @objc private func createButtonTapped() {
        let trackerTitleName = habitNameTextField.text ?? ""
        
        guard let emojiIndex = selectedEmojiIndexPath else { return }
        let selectedEmoji = emojiesAndColors.emojies[emojiIndex.row]
        
        
        guard let colorIndex = selectedColorIndexPath else { return }
          let selectedColor = emojiesAndColors.colors[colorIndex.row]
        
        
        self.delegate?.didSelectNewTracker(newTracker: TrackerCategory(title: "Новая Категория",
                                                                       trackers: [Tracker.init(id: UUID(),
                                                                                               title: trackerTitleName,
                                                                                               color: selectedColor,
                                                                                               emoji: selectedEmoji,
                                                                                               schedule: self.schedule)]))
        
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func createButtonIsEnabled() {
        if habitNameTextField.text?.isEmpty == false && (currentCatergory?.isEmpty != nil ) && (selectedColorIndexPath != nil) && (selectedEmojiIndexPath != nil) {
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
            if schedule.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                let scheduleShortValueText = schedule.map { $0.shortValue }.joined(separator: ",")
                cell.detailTextLabel?.text = scheduleShortValueText
            }
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

// MARK: - UICollectionViewDataSource

extension AddNewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojiesAndColors.emojies.count
        case 1:
            return emojiesAndColors.colors.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionView.headerIdentifier, for: indexPath) as? HeaderCollectionView else{ return UICollectionReusableView()}
      
        switch indexPath.section {
        case 0:
            let emojiesTitle = emojiesAndColors.emojiesTitle
            view.configureHeader(title: emojiesTitle)
        case 1:
            let colorTitle = emojiesAndColors.colorTitle
            view.configureHeader(title: colorTitle)
        default: break
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellEmoji = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewTrackerEmojiesViewCell.addNewTrackerEmojiesViewCellIdentifier, for: indexPath) as? AddNewTrackerEmojiesViewCell else { return UICollectionViewCell() }
        
        guard let cellColor = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewTrackerColorViewCell.addNewTrackerColorViewCellIdentifier, for: indexPath) as? AddNewTrackerColorViewCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            cellEmoji.emojiLabel.text = emojiesAndColors.emojies[indexPath.row]
            return cellEmoji
        case 1:
            cellColor.colorViewFront.backgroundColor = emojiesAndColors.colors[indexPath.row]
            return cellColor
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    
        
        
        switch indexPath.section {
        case 0:
            
            if let selectedEmojiIndexPath,
               let previousCell = collectionView.cellForItem(at: selectedEmojiIndexPath) as? AddNewTrackerEmojiesViewCell {
                previousCell.deselected()
            }
           
            guard let cellEmoji = collectionView.cellForItem(at: indexPath) as? AddNewTrackerEmojiesViewCell else { return }
            cellEmoji.selected()
            selectedEmojiIndexPath = indexPath
                
                

           
            

        case 1:
            
            
           
            if let selectedColorIndexPath,
               let previousCell = collectionView.cellForItem(at: selectedColorIndexPath) as? AddNewTrackerColorViewCell {
                previousCell.deselectedColor()
            }
            guard let cellColor = collectionView.cellForItem(at: indexPath) as? AddNewTrackerColorViewCell else { return }
            let coloru = emojiesAndColors.colors[indexPath.row]
            cellColor.selectedColor(forColor: coloru)
            selectedColorIndexPath = indexPath

        default: break
        }
       
        
        createButtonIsEnabled()
    }
    

}
// MARK: - UICollectionViewDelegate
extension AddNewTrackerViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddNewTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 32)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {// горизонт отступ между яч 5
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // вертик оотступ между ячейками 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // размер ячейки 52х52
        let availableWifth = collectionView.frame.width - paramsForAddNewTrackerCell.paddingWidth
        let cellWidth = availableWifth / CGFloat(paramsForAddNewTrackerCell.cellCount)
        return CGSize(width: 52, height: 52)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
}
