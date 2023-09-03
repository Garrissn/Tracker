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
private enum LocalisedCases {
    static let editTrackerLabelText = NSLocalizedString("editHabitTracker.title", comment: "Title of edited habit")
    static let habitTrackerLabelText = NSLocalizedString("newRegularEvent.title", comment: "Title of new habit")
    static let irregularEventTrackerLabelText = NSLocalizedString("newIrregularEvent.title", comment: "Title of new irregulat habit")
    static let textFieldPlaceHolderText = NSLocalizedString("textField.tracker.title", comment: "Title of attributedPlaceholder in textfield")
    static let cancelButtonText = NSLocalizedString("button.cancel.title", comment: "Text on cancelButton")
    static let createButtonText = NSLocalizedString("button.create.title", comment: "Text on createButton")
    static let createButtonSaveText = NSLocalizedString("button.createSave.title", comment: "Text on createButton")
    
    static let categoryLabelText = NSLocalizedString("category.title", comment: "Text on tableview category")
    static let scheduleLabelText = NSLocalizedString("schedule.title", comment: "Text on tableview schedule")
}

final class AddNewTrackerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        switch trackerType {
        case .none:
            break
        case .habitTracker: label.text = LocalisedCases.habitTrackerLabelText
        case .irregularIvent: label.text = LocalisedCases.irregularEventTrackerLabelText
        case .editHabitTracker: label.text = LocalisedCases.editTrackerLabelText
        }
        label.textColor = .TrackerBlack
        label.font = UIFont.ypMedium16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .TrackerBlack
        label.text = "5дней"
        label.font = UIFont.ypBold32()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .TrackerBackGround
        textField.layer.cornerRadius = 16
        
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedPlaceHolder = NSAttributedString(string: LocalisedCases.textFieldPlaceHolderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceHolder
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let leftInsertView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 30))
        textField.leftView = leftInsertView
        textField.leftViewMode = .always
        textField.textColor = .Gray
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
        tableView.backgroundColor = .TrackerBackGround
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.register(AddNewTrackerTableViewCell.self, forCellReuseIdentifier: AddNewTrackerTableViewCell.AddNewTrackerTableViewCellIdentifier)
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
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AddNewTrackerEmojiesViewCell.self, forCellWithReuseIdentifier: AddNewTrackerEmojiesViewCell.addNewTrackerEmojiesViewCellIdentifier)
        collectionView.register(AddNewTrackerColorViewCell.self, forCellWithReuseIdentifier: AddNewTrackerColorViewCell.addNewTrackerColorViewCellIdentifier)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.headerIdentifier)
        collectionView.backgroundColor = .TrackerWhite
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private let uiColorMarsh = UIColorMarshalling()
    private lazy var cancellButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalisedCases.cancelButtonText, for: .normal)
        button.setTitleColor(.Red, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.tintColor = .Red
        button.backgroundColor = .TrackerWhite
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
        switch trackerType {
        case .none:
            break
        case .habitTracker: button.setTitle(LocalisedCases.createButtonText, for: .normal)
        case .irregularIvent: button.setTitle(LocalisedCases.createButtonText, for: .normal)
        case .editHabitTracker: button.setTitle(LocalisedCases.createButtonSaveText, for: .normal)
        }
        //  button.setTitle(LocalisedCases.createButtonText, for: .normal)
        button.titleLabel?.font = UIFont.ypMedium16()
        button.setTitleColor(.TrackerBlack, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .Gray
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    private var currentCatergory: String?
    private var schedule: [WeekDay] = []
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    private var newTrackerText: String = ""
    private var heightTableView: CGFloat = 75
    private let emojiesAndColors: EmojiesAndColors = EmojiesAndColors()
    private let helper = HelpersFunction()
    weak var delegate: AddNewTrackerViewControllerDelegate?
    var trackerType: TrackerType?
    var editingTrackerCategory: TrackerCategory?
    var numberOfRecordsEditedTracker: Int?
    private let paramsForAddNewTrackerCell = GeometricParams(cellCount:6,
                                                             leftInset: 0, rightInset: 0, cellSpacing: 5)
    
    
    
    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .TrackerWhite
        collectionView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        editingTracker()
    }
    
    // MARK: - Private Methods
    
    private func editingTracker() {
        if let editingTrackerCategory = editingTrackerCategory {
            self.habitNameTextField.text = editingTrackerCategory.trackers[0].title
            self.currentCatergory = editingTrackerCategory.title
            self.schedule = editingTrackerCategory.trackers[0].schedule
            let colorIndexPath = helper.convertStringToIndexPath(editingTrackerCategory.trackers[0].selectedColorIndexPath)
            let emojiIndexPath = helper.convertStringToIndexPath(editingTrackerCategory.trackers[0].selectedEmojiIndexPath)
            self.selectedEmojiIndexPath = emojiIndexPath
            self.selectedColorIndexPath = colorIndexPath
            
        }
        if let numberOfRecordsEditedTracker = numberOfRecordsEditedTracker {
            self.numberOfRecordsEditedTracker = numberOfRecordsEditedTracker
            let daysIndex = helper.pluralizeDays(numberOfRecordsEditedTracker)
            countDaysLabel.text = "\(daysIndex)"
        }
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(conteinerView)
        
        conteinerView.addSubview(titleLabel)
        conteinerView.addSubview(countDaysLabel)
        conteinerView.addSubview(habitNameTextField)
        conteinerView.addSubview(tableView)
        conteinerView.addSubview(collectionView)
        conteinerView.addSubview(cancellButton)
        conteinerView.addSubview(createButton)
        
    }
    
    private func setupConstraints() {
        switch trackerType {
        case.editHabitTracker:
            countDaysLabel.isHidden = false
            heightTableView = 150
            NSLayoutConstraint.activate([
                habitNameTextField.topAnchor.constraint(equalTo: countDaysLabel.bottomAnchor, constant: 38),
            ])
        case .habitTracker: heightTableView = 150
            NSLayoutConstraint.activate([
                habitNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            ])
        case .irregularIvent: heightTableView = 75
            NSLayoutConstraint.activate([
                habitNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            ])        case.none: break
        }
        enum topConstraint {
            case titleLabel
            case countDaysLabel
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
            
            countDaysLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            countDaysLabel.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            countDaysLabel.heightAnchor.constraint(equalToConstant: 38),
            
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
        
        let selectedEmojiTracker = helper.convertIndexPathToString(emojiIndex)
        
        guard let colorIndex = selectedColorIndexPath else { return }
        let selectedColor = emojiesAndColors.colors[colorIndex.row]
        let colorIndexTracker = helper.convertIndexPathToString(colorIndex)
        
        let category = TrackerCategory(title: currentCatergory ?? "Без категории", trackers: [])
        var editedzUUID: UUID?
        var edittedIsPinned: Bool?
        if let editingTrackerCategory = editingTrackerCategory  {
             let zeditedzUUID = editingTrackerCategory.trackers.first?.id
             let zedittedIsPinned = editingTrackerCategory.trackers.first?.isPinned
            editedzUUID = zeditedzUUID
            edittedIsPinned = zedittedIsPinned
        }
        var scheduleForNewTracker = [WeekDay]()
        if schedule.count > 0 {
            print(schedule)
            scheduleForNewTracker = self.schedule
        } else {
            scheduleForNewTracker = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        }
        
        let newTracker = Tracker(isPinned: edittedIsPinned ?? false,
                                 id: editedzUUID ?? UUID(),
                                 title: trackerTitleName,
                                 color: selectedColor,
                                 emoji: selectedEmoji,
                                 schedule: scheduleForNewTracker,
                                 selectedEmojiIndexPath: selectedEmojiTracker,
                                 selectedColorIndexPath: colorIndexTracker
        )
        
        let userInfo: [String: Any] = [ "Category": category, "NewTracker": newTracker]
        if trackerType == .editHabitTracker {
            NotificationCenter.default.post(name: NSNotification.Name("EditedTrackerNotification"), object: nil, userInfo: userInfo)
            dismiss(animated: true, completion: nil)
        } else {
            self.delegate?.didSelectNewTracker(newTracker: TrackerCategory(
                title: currentCatergory ?? "",
                trackers: [newTracker]))
     
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
        
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func createButtonIsEnabled() {
        if habitNameTextField.text?.isEmpty == false && (currentCatergory?.isEmpty != nil ) && (selectedColorIndexPath != nil) && (selectedEmojiIndexPath != nil) {
            createButton.backgroundColor = .TrackerBlack
            createButton.setTitleColor(.TrackerWhite, for: .normal)
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .Gray
            createButton.setTitleColor(.TrackerWhite, for: .normal)
            createButton.isEnabled = false
        }
    }
}

// MARK: - AddscheduleViewControllerDelegate

extension AddNewTrackerViewController : AddscheduleViewControllerDelegate {
    func didSelectScheduleValue(_ value: [WeekDay]) {
        self.schedule = value
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
        if range.location == 0 &&  string == " " { return false }
        switch trackerType {
        case .editHabitTracker:
            if schedule.isEmpty == false {
                createButtonIsEnabled()
                return true
            }
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
        case .editHabitTracker: return 2
        case .habitTracker: return 2
        case .irregularIvent: return 1
        case .none: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNewTrackerTableViewCell.AddNewTrackerTableViewCellIdentifier) as? AddNewTrackerTableViewCell else { return UITableViewCell()}
        switch indexPath.row {
        case 0:
            cell.configureTableViewCellForCategory(cellTitle: LocalisedCases.categoryLabelText, detailTextLabelText: currentCatergory ?? "")
        case 1:
            cell.configureTableViewCellForSchedule(cellTitle: LocalisedCases.scheduleLabelText, shcedule: schedule)
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            
            let model = AddCategoryModel()
            let viewModel = AddCategoryViewModel(model: model)
            let value = currentCatergory ?? " "
            let addCategoryVC = AddCategoryViewController(viewModel: viewModel, categoryTitle: value)
            addCategoryVC.bind()
            addCategoryVC.delegate = self
            present(addCategoryVC, animated: true)
            
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        SeparatorLineHelper.configSeparatingLine(tableView: tableView, cell: cell, indexPath: indexPath)
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
            if let editingTrackerCategory = editingTrackerCategory {
                if emojiesAndColors.emojies[indexPath.row] == editingTrackerCategory.trackers[0].emoji {
                    cellEmoji.selected()
                }
            }
            
            return cellEmoji
        case 1:
            cellColor.colorViewFront.backgroundColor = emojiesAndColors.colors[indexPath.row]
            
            let cr = emojiesAndColors.colors[indexPath.row]
            let hexStr = uiColorMarsh.hexString(from: cr)
            let crm = uiColorMarsh.color(from: hexStr)
            
            if let editingTrackerCategory = editingTrackerCategory {
                let color = editingTrackerCategory.trackers[0].color
                if color == crm {
                    let coloru = emojiesAndColors.colors[indexPath.row]
                    cellColor.selectedColor(forColor: coloru)
                }
            }
            
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
        _ = availableWifth / CGFloat(paramsForAddNewTrackerCell.cellCount)
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
}

extension AddNewTrackerViewController: AddCategoryViewControllerDelegate {
    func didNewCategorySelect(categoryTitle: String) {
        currentCatergory = categoryTitle
        tableView.reloadData()
    }
}


