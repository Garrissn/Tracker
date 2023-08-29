//
//  ViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 21.06.2023.
//

import UIKit

class MainScreenTrackerViewController: UIViewController {
    private let analiticService = AnaliticsService.shared
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CardTrackerViewCell.self, forCellWithReuseIdentifier: CardTrackerViewCell.cardTrackerViewCellIdentifier)
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    private lazy var placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "error")
        imageView.image = image
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeHolderText: UILabel = {
        let label = UILabel ()
        label.text = MainscreenLocalize.placeHolderLabelText
        label.textColor = .TrackerBlack
        label.font = UIFont.ypMedium12()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "dd.MM.yy"
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .Blue
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        return datePicker
    }()
    
    private lazy var searchBar: TrackerSearchBar = {
        let searchBar = TrackerSearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.addTarget(self, action: #selector(searchBarTapped), for: .editingDidEndOnExit)
        return searchBar
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.tintColor = .Blue
        cancelButton.titleLabel?.font = UIFont(name: "SP-Pro", size: 17)
        cancelButton.isHidden = true
        return cancelButton
    }()
    
    private let filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.setTitle(MainscreenLocalize.filterButtonText, for: .normal)
        filterButton.backgroundColor = .blue
        filterButton.titleLabel?.font = UIFont.ypRegular17()
        filterButton.tintColor = .white
        filterButton.addTarget(self, action: #selector(selectFilterTapped), for: .touchUpInside)
        filterButton.layer.cornerRadius = 16
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.isHidden = true
        return filterButton
    }()
    
    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 9,
        rightInset: 16,
        cellSpacing: 16)
    
    private var completedTrackers: [TrackerRecord] = [] // трекуры выполненные в выбранную дату
    private var currentDate: Date
    private let dataManager = DataManager.shared
    let dete = Date()
    private let trackerDataManager: TrackerDataManagerProtocol
    private var isPinned = false
    private var titleTextPinnedTracker: String = ""
    private var pinnedTracker: Tracker?
    private let uiColorMarshalling = UIColorMarshalling()
    init(trackerDataManager: TrackerDataManagerProtocol) {
        currentDate = Date()
        self.trackerDataManager = trackerDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupCollectionView()
        setupConstraints()
        configureView()
        setupNavigationBar()
        trackerDataManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(getEditedTracker(_:)), name: Notification.Name("EditedTrackerNotification"), object: nil)
        
        //
        dateChanged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analiticService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analiticService.report(event: "close", params: ["screen": "Main"])
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        view.backgroundColor = .TrackerWhite
        // searchTextField.returnKeyType = .done
        filterButton.layer.zPosition = 2
    }
    
    private func reloadData() {
        let filterText = (searchBar.searchTextField.text ?? "").lowercased()
        currentDate = datePicker.date
        let weekDay = currentDate.weekDayNumber()
        if let weekDayString = WeekDay.allCases.first(where: { $0.numberValue == weekDay})
        { trackerDataManager.fetchSearchCategories(textToSearch: filterText, weekDay: weekDayString.rawValue)}
        collectionView.reloadData()
        reloadPlaceHolder(for: .notFound)
    }
    
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.headerIdentifier)
    }
    
    private func addViews() {
        
        view.addSubview(searchBar)
        view.addGestureRecognizer(tapGesture)
        view.addSubview(placeHolderImageView)
        view.addSubview(placeHolderText)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeHolderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 80),
            
            placeHolderText.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            placeHolderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderText.heightAnchor.constraint(equalToConstant: 18),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func addTask() {
        
        analiticService.report(event: "click", params: [
            "screen": "Main",
            "item": "add_track"
        ])
        
        let trackerTypeSelectionViewController = TrackerTypeSelectionViewController()
        trackerTypeSelectionViewController.delegate = self
        let navVC = UINavigationController(rootViewController: trackerTypeSelectionViewController)
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged() {
        currentDate = datePicker.date
        self.dismiss(animated: false)
        reloadData()
    }
    
    @objc private func getEditedTracker(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let category = userInfo["Category"] as? TrackerCategory,
               let tracker = userInfo["NewTracker"] as? Tracker {
                var categoryEntity: TrackerCategoryEntity?
                if let existedCategory = self.trackerDataManager.fetchCategory(title: category.title) {
                    categoryEntity = existedCategory// запросили название категории в кор дате с названием редакт категории
                } else {
                    do {
                        let newCategory = try self.trackerDataManager.createCategory(category: TrackerCategory(title: category.title, trackers: [])) // если нет такого создали категорию новую с этим названием
                        categoryEntity = newCategory
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                guard let categoryEntity = categoryEntity else { return }
                var apdatedTrackerEntity: TrackerEntity?
                if let existedTrackerEntity = self.trackerDataManager.fetchTracker(id: tracker.id.uuidString) {
                    apdatedTrackerEntity = existedTrackerEntity // запросили в кор дате все трекер с редак айди
                }
                guard let apdatedTrackerEntity = apdatedTrackerEntity else { return } // теперь в нем заменим все поля на новые
                apdatedTrackerEntity.trackerId = tracker.id.uuidString
                apdatedTrackerEntity.title = tracker.title
                apdatedTrackerEntity.emoji = tracker.emoji
                let color = tracker.color
                let hexColor = uiColorMarshalling.hexString(from: color)
                apdatedTrackerEntity.color = hexColor
                apdatedTrackerEntity.isPinned = tracker.isPinned
                apdatedTrackerEntity.selectedColorIndexPath = tracker.selectedColorIndexPath
                apdatedTrackerEntity.selectedEmojiIndexPath = tracker.selectedEmojiIndexPath
                let schedule = tracker.schedule
                let trackerSchedule = trackerDataManager.convertScheduleArrayToScheduleEntity(schedule)
                apdatedTrackerEntity.addToSchedule(trackerSchedule)
                
                do {
                    try trackerDataManager.updateTracker(trackerEntity: apdatedTrackerEntity, trackerCategoryEntity: categoryEntity, trackerTitle: tracker.title)
                } catch {
                    showAlertController(text: "Ошибка добавления нового трекера. Попробуйте еще раз")
                }
            }
        }
        reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func  searchBarTapped() {
        reloadData()
    }
    
    @objc private func  selectFilterTapped() {
        analiticService.report(event: "click", params: ["screen": "Main",
                                                        "item": "filter"])
        let filterViewController = FilterViewController()
        present(filterViewController, animated: true)
    }
    
    private func  setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let imageButton = UIImage(named: "PlusButton")
            let button = UIButton(type: .system)
            button.tintColor = .TrackerBlack
            button.setImage(imageButton, for: .normal)
            button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
            
            let leftButton = UIBarButtonItem(customView: button)
            navBar.topItem?.setLeftBarButton(leftButton, animated: true)
            
            let rightButton = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.setRightBarButton(rightButton, animated: true)
            let localizedTitle = NSLocalizedString(
                "trackers.title",
                comment: "Title of the trackers on the navigation bar"
            )
            navigationItem.title = localizedTitle
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func reloadPlaceHolder(for view: PlaceHolder) {
        if trackerDataManager.numberOfTrackers == 0 {
            placeHolderText.isHidden = false
            placeHolderImageView.isHidden = false
            filterButton.isHidden = true
            switch view {
            case .notFound:
                placeHolderImageView.image = UIImage(named: "error")
                placeHolderText.text = MainscreenLocalize.placeHolderLabelText
            case .whatToTrack:
                
                placeHolderImageView.image = UIImage(named: "errorNothingFound")
                placeHolderText.text = MainscreenLocalize.placeholderNothingFoundText
            }
        } else {
            placeHolderText.isHidden = true
            placeHolderImageView.isHidden = true
            filterButton.isHidden = false
        }
    }
}

// MARK: - TextFieldDelegate

extension MainScreenTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reloadData()
        return true
    }
}

// MARK: - SearchBarDelegate methods

extension MainScreenTrackerViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadData()
        searchBar.resignFirstResponder()
    }
}
// MARK: - UICollectionViewDataSource
extension MainScreenTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerDataManager.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerDataManager.numberOfRowsInSection(section: section)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionView.headerIdentifier, for: indexPath) as? HeaderCollectionView else { return UICollectionReusableView()}
        let sectionName = trackerDataManager.nameOfSection(section: indexPath.section)
        
        
        view.configureHeader(title: sectionName)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardTrackerViewCell.cardTrackerViewCellIdentifier, for: indexPath) as? CardTrackerViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.contextMenuDelegate = self
        
        
        
        
        
        guard  let cellViewModel = configColViewCell(indexPath: indexPath) else { return CardTrackerViewCell()}
        cell.configure(with: cellViewModel)
        return cell
    }
    
    private func configColViewCell(indexPath: IndexPath) -> CardTrackerViewModel? {
        guard let tracker = trackerDataManager.getTrackerObject(indexPath: indexPath) else { return nil }
        
        let isCompletedToday = trackerDataManager.recordExists(forId: tracker.id, date: dateFormatter.string(from: datePicker.date))
        let completedDays = trackerDataManager.numberOfRecords(forId: tracker.id)
        return CardTrackerViewModel(tracker: tracker,
                                    isCompletedToday: isCompletedToday,
                                    completedDays: completedDays,
                                    indexPath: indexPath,
                                    currentDate: datePicker.date)
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        let complTrackers = trackerDataManager.recordExists(forId: id, date: dateFormatter.string(from: datePicker.date))
        return complTrackers
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return  trackerRecord.trackerId == id && isSameDay
    }
}

// MARK: - UICollectionViewDelegate
extension MainScreenTrackerViewController: ContextMenuInteractionDelegate {
    
    func contextMenuConfiguration(at indexPath: IndexPath) -> UIContextMenuConfiguration? {
        
        guard let pinnedTracker = trackerDataManager.getTrackerObject(indexPath: indexPath) else { return UIContextMenuConfiguration()}
        
        let pinnedTrackerId = pinnedTracker.id
        if pinnedTracker.isPinned {
            titleTextPinnedTracker = "Открепить"
            isPinned = false
        } else {
            isPinned = true
            titleTextPinnedTracker = "Закрепить"
        }
        
        let pinOrUnpinAction = UIAction(title: titleTextPinnedTracker) { [weak self] _ in
            guard let self else { return }
            do {
                // try trackerDataManager.trackerIsPinned(isPinned: isPinned, tracker: pinnedTracker)
                try trackerDataManager.trackerIsPinned(indexPath: indexPath)
            } catch {
                showAlertController(text: "error")
            }
            self.dateChanged()
            collectionView.reloadItems(at: [indexPath])
        }
        
        let editAction = UIAction(title: "Редактировать") {[weak self] _ in
            guard let self else { return }
            analiticService.report(event: "click", params: [
                "screen": "Main",
                "item": "edit"
            ])
            
            let categoryName = self.trackerDataManager.getTrackerCategoryName(indexPath: indexPath)
            
            let numberOfRecords =  trackerDataManager.numberOfRecords(forId: pinnedTrackerId)
            let trackerForEditing = TrackerCategory(title: categoryName, trackers: [pinnedTracker])
            let addNewTrackerVC = AddNewTrackerViewController()
            addNewTrackerVC.numberOfRecordsEditedTracker = numberOfRecords
            addNewTrackerVC.editingTrackerCategory = trackerForEditing
            addNewTrackerVC.trackerType = .editHabitTracker
            present(addNewTrackerVC, animated: true)
        }
        
        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) {[weak self] _ in
            guard let self else { return }
            analiticService.report(event: "click", params: [
                "screen": "Main",
                "item": "delete"
            ])
            deleteItem(at: indexPath)
        }
        
        let menu = UIMenu(children: [pinOrUnpinAction, editAction, deleteAction])
        return UIContextMenuConfiguration(actionProvider: { _ in menu })
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Уверены, что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.deleteTracker(at: indexPath)
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func deleteTracker(at indexPath: IndexPath) {
        do {
            let trackerEntity =  trackerDataManager.getTrackerCoreData(indexPath: indexPath)
            let tracker = try trackerDataManager.getTracker(from: trackerEntity)
            try trackerDataManager.deleteTracker(tracker: tracker)
            //try trackerDataManager.deleteTracker(trackerEntity: trackerEntity )
        } catch {
            showAlertController(text: "error while deleting Tracker")
        }
    }
}




// MARK: - CardTrackerViewCellDelegate

extension MainScreenTrackerViewController: CardTrackerViewCellDelegate {
    func completedTracker(id: UUID,at indexPath: IndexPath) {
        let realDate = Date()
        if realDate < currentDate {
            print("Попытка изменить количество выполнений трекера в будущей дате")
        } else {
            
            do {
                try  trackerDataManager.addTrackerRecord(forId: id, date: dateFormatter.string(from: datePicker.date))
            } catch {
                showAlertController(text: "Ошибка добавления записи. Попробуйте еще раз")
            }
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID,at indexPath: IndexPath) {
        let realDate = Date()
        if realDate < currentDate {
            print("Попытка изменить количество выполнений трекера в будущей дате")
        } else {
            
            do {
                try trackerDataManager.deleteTrackerRecord(forId: id, date: dateFormatter.string(from: datePicker.date))
            } catch {
                showAlertController(text: "Ошибка добавления записи. Попробуйте еще раз")
            }
            
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension MainScreenTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 49)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.leftInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        
        return CGSize(width: cellWidth, height: 148)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: params.rightInset, bottom: params.rightInset, right: params.rightInset)
    }
    
}
// MARK: - TrackerTypeSelectionViewControllerDelegate

extension MainScreenTrackerViewController: TrackerTypeSelectionViewControllerDelegate {
    func didselectNewTracker(newTracker: TrackerCategory) {
//        dismiss(animated: true)
//        var trackerCategory = newTracker
//        let trackersSchedule = trackerCategory.trackers[0].schedule
//        if trackersSchedule.isEmpty {
//            guard let numberOfDay = currentDate.weekDayNumber() else { return }
//            var currentDay = numberOfDay
//            if numberOfDay == 1 {
//                currentDay = 8
//            }
//            let newSchedule = WeekDay.allCases[currentDay - 2]
//            let updatedTracker = Tracker(isPinned: false,
//                                         id: trackerCategory.trackers[0].id,
//                                         title: trackerCategory.trackers[0].title,
//                                         color: trackerCategory.trackers[0].color,
//                                         emoji: trackerCategory.trackers[0].emoji,
//                                         schedule: (trackersSchedule) + [newSchedule],
//                                         selectedEmojiIndexPath: trackerCategory.trackers[0].selectedEmojiIndexPath,
//                                         selectedColorIndexPath: trackerCategory.trackers[0].selectedColorIndexPath)
//            var updatedTrackers = trackerCategory.trackers
//            updatedTrackers[0] = updatedTracker
//            trackerCategory = TrackerCategory(title: trackerCategory.title, trackers: updatedTrackers)
//            do {
//                try trackerDataManager.addTrackerCategory(trackerCategory)
//            } catch {
//                showAlertController(text: "Ошибка добавления нового трекера. Попробуйте еще раз")
//            }
//
//        } else {
//            do {
//                try trackerDataManager.addTrackerCategory(trackerCategory)
//            } catch {
//                showAlertController(text: "Ошибка добавления нового трекера. Попробуйте еще раз")
//            }
//        }
        
        var trackerCategory = newTracker
        let trackerCategoryTitle = trackerCategory.title
        guard let tracker = trackerCategory.trackers.first else { print (" не удалось взять первый трекер")
            return }
        var categoryEntity: TrackerCategoryEntity?
        if let existingCategory = self.trackerDataManager.fetchCategory(title: trackerCategoryTitle) {
            categoryEntity = existingCategory
        } else {
            do {
                let newCategory = try self.trackerDataManager.createCategory(category: TrackerCategory(title: trackerCategoryTitle, trackers: []))
            } catch {
                print(error.localizedDescription)
            }
        }
        guard let categoryEntity = categoryEntity else { return }
        do {
            try self.trackerDataManager.addTracker(tracker: tracker, trackerCategoryEntity: categoryEntity)
        } catch {
            print(error.localizedDescription)
        }
            
    }
    
    
}

extension MainScreenTrackerViewController: TrackerDataManagerDelegate {
    func updateView() {
        reloadData()
        reloadPlaceHolder(for: .notFound)
        collectionView.reloadData()
    }
}

extension Date {
    func weekDayNumber() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

extension MainScreenTrackerViewController {
    func showAlertController(text message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(actionButton)
        present(alertController, animated: true)
    }
}

private enum MainscreenLocalize {
    static let placeHolderLabelText = NSLocalizedString("placeholder.emptyTrackers.title", comment: "Title of the placeHolder whats to track")
    static let searchBarplaceHolderText = NSLocalizedString("searchBar.placeholder.title", comment: "Title of the placeHolder on searchbar")
    static let filterButtonText = NSLocalizedString("button.filters.title", comment: "Title of the filterbuttontext")
    static let placeholderNothingFoundText = NSLocalizedString("placeholder.nothingFound.title", comment: "Title of the placeHolder nothingFound")
}

enum PlaceHolder {
    case notFound
    case whatToTrack
}





