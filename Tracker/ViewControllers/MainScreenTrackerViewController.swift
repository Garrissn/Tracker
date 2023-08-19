//
//  ViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 21.06.2023.
//

import UIKit

class MainScreenTrackerViewController: UIViewController {
  
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
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .BackGroundDay
        textField.layer.cornerRadius = 16
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedPlaceHolder = NSAttributedString(string: MainscreenLocalize.searchBarplaceHolderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceHolder
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        textField.textColor = .BlackDay
        textField.font = UIFont.ypRegular17()
        textField.delegate = self
        return textField
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
    
    private var insertedIndexesInSearch: [IndexPath] = []
    private var removedIndexesInSearch: [IndexPath] = []
    private var insertedSectionsInSearch: IndexSet = []
    private var removedSectionsInSearch: IndexSet = []
    private var completedTrackers: [TrackerRecord] = [] // трекуры выполненные в выбранную дату
    private var currentDate: Date
    private let dataManager = DataManager.shared
    private var visibleCatergories: [TrackerCategory] = [] // массив который пользователь увидит после фильтр
    private var categoriesAll: [TrackerCategory] = []
            let dete = Date()
    private let trackerDataManager: TrackerDataManagerProtocol
    private var isPinned = false
    private var titleTextPinnedTracker: String = ""
    
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
        reloadData()
        reloadVisibleCategories(categories: visibleCatergories)
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        view.backgroundColor = .TrackerWhite
        searchTextField.returnKeyType = .done
        filterButton.layer.zPosition = 2
    }
    
    private func reloadData() {
        let weekDay = currentDate.weekDayNumber()
        if let weekDayString = WeekDay.allCases.first(where: { $0.numberValue == weekDay})
        { trackerDataManager.fetchCategoriesFor(weekDay: weekDayString.rawValue, animating: true)
            print( " weekdayStringRaw \(weekDayString.rawValue)")
        }
        
        self.rlVC()
        
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
        view.addSubview(searchTextField)
        view.addSubview(placeHolderImageView)
        view.addSubview(placeHolderText)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            placeHolderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 80),
            
            placeHolderText.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            placeHolderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderText.heightAnchor.constraint(equalToConstant: 18),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func addTask() {
        let trackerTypeSelectionViewController = TrackerTypeSelectionViewController()
        trackerTypeSelectionViewController.delegate = self
        let navVC = UINavigationController(rootViewController: trackerTypeSelectionViewController)
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged() {
        currentDate = datePicker.date
        let ret = dateFormatter.string(from: datePicker.date)
        self.dismiss(animated: false)
        let weekDay = currentDate.weekDayNumber()
       
        if let weekDayString = WeekDay.allCases.first(where: { $0.numberValue == weekDay})
        { trackerDataManager.fetchCategoriesFor(weekDay: weekDayString.rawValue, animating: true)
            print( " weekdayStringRaw \(weekDayString.rawValue)")
        } else {
            print("ошибка дейтпикера")
        }
        rlVC()
        reloadPlaceHolder(for: .whatToTrack)
      //  guard let weeksString = WeekDay.allCases.first(where: { $0.numberValue == currentDate.weekDayNumber()}) else { print ("date error")}
        
    }
   
    
    @objc private func  selectFilterTapped() {
        print("filter Tapped")
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
    
    private func reloadVisibleCategories(categories: [TrackerCategory]) {
//        let filterText = (text ?? "").lowercased()
//        let filterWeekday = currentDate.weekDayNumber()
//        if let filterWeekDayString = WeekDay.allCases.first(where: { $0.numberValue == filterWeekday}) {
//            trackerDataManager.fetchSearchCategories(textToSearch: filterText, weekDay: filterWeekDayString.rawValue)
//        }
      //  _ = categories
       // categoriesAll.compactMap { category in
            //let trackers = category.trackers.filter { $0.isPinned
              //  let textCondition = filterText.isEmpty ||
               // tracker.title.lowercased().contains(filterText)
               // let dateCondition = tracker.schedule.contains { weekDay in
                  //  weekDay.numberValue == filterWeekday
              //  } == true
              //  return textCondition && dateCondition
         //   }
          //  if trackers.isEmpty {
          //      return nil
//            }
//            return TrackerCategory(title: "ategory.title", trackers: trackers)
//
//                guard let weeksString = WeekDay.allCases.first(where: { $0.numberValue == currentDate.weekDayNumber()}) else { print ("date error")}
//                let categoriesy = trackerDataManager.fetchCategoriesFor(weekDay: weeksString.rawValue, animating: true)
//                visibleCatergories = categoriesy.map
//        }
        
        
        
        
        //collectionView.reloadData()
       // reloadPlaceHolder(for: .whatToTrack)
    }
    
    private func rlVC() {
        var sortedCategories: [TrackerCategory] = []
        var sortedPinnedcategories: [TrackerCategory] = []
        var sortedUnpinnedCategories: [TrackerCategory] = []
        
        sortedPinnedcategories = visibleCatergories.compactMap({ category in
            let trackers = category.trackers.filter { $0.isPinned }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(title: "Закрепленные", trackers: trackers)
        })
        for category in sortedPinnedcategories {
                print(category.title)
            }
        sortedUnpinnedCategories = visibleCatergories.compactMap({ category in
            let trackers = category.trackers.filter { !$0.isPinned }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        })
        sortedCategories = sortedPinnedcategories + sortedUnpinnedCategories
        for category in sortedCategories {
                print(category.title)
            }
        visibleCatergories = sortedCategories
       
        for category in visibleCatergories {
                print("visible category titles:\(category.title)")
            }
        collectionView.reloadData()
        reloadPlaceHolder(for: .notFound)
    }
    
    private func reloadPlaceHolder(for view: PlaceHolder) {
        if visibleCatergories.isEmpty  {
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
        textField.resignFirstResponder()
        let filterText = (textField.text ?? "").lowercased()
        if  !filterText.isEmpty {
            if let filterWeekDayString = WeekDay.allCases.first(where: { $0.numberValue == currentDate.weekDayNumber()}) {
                trackerDataManager.fetchSearchCategories(textToSearch: filterText, weekDay: filterWeekDayString.rawValue)
            }
        } else {
            if let filterWeekDayString = WeekDay.allCases.first(where: { $0.numberValue == currentDate.weekDayNumber()}) {
                trackerDataManager.fetchCategoriesFor(weekDay: filterWeekDayString.rawValue, animating: true)
            }
        }
        return true
    }
}
// MARK: - UICollectionViewDataSource
extension MainScreenTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCatergories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = visibleCatergories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionView.headerIdentifier, for: indexPath) as? HeaderCollectionView else { return UICollectionReusableView()}
        let titleCategory = visibleCatergories[indexPath.section].title
        view.configureHeader(title: titleCategory)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardTrackerViewCell.cardTrackerViewCellIdentifier, for: indexPath) as? CardTrackerViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.contextMenuDelegate = self
        let cellViewModel = configColViewCell(indexPath: indexPath)
        cell.configure(with: cellViewModel)
        return cell
    }
    
    private func configColViewCell(indexPath: IndexPath) -> CardTrackerViewModel {
        let cellData = visibleCatergories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
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
        
        let trackerIsPinned = self.visibleCatergories[indexPath.section].trackers[indexPath.row]

            if trackerIsPinned.isPinned {
                titleTextPinnedTracker = "Открепить"
                isPinned = false
            } else {
                isPinned = true
                titleTextPinnedTracker = "Закрепить"
            }
        let pinOrUnpinAction = UIAction(title: titleTextPinnedTracker) { [weak self] _ in
            guard let self else { return }
            do {
                try trackerDataManager.trackerIsPinned(isPinned: isPinned, tracker: trackerIsPinned)
            } catch {
                showAlertController(text: "error")
            }
            self.dateChanged()
            collectionView.reloadData()
        }
        
        let editAction = UIAction(title: "Редактировать") { _ in
            print("Tapped EDIT for tracker")
        }
        
        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) {[weak self] _ in
            guard let self else { return }
            do {
                try trackerDataManager.deleteTracker(tracker: trackerIsPinned)
            } catch {
                showAlertController(text: "error while deleting Tracker")
            }
            self.dateChanged()
            collectionView.reloadData()
        }
        
        let menu = UIMenu(children: [pinOrUnpinAction, editAction, deleteAction])
        return UIContextMenuConfiguration(actionProvider: { _ in menu })
    }
}


// MARK: - CardTrackerViewCellDelegate

extension MainScreenTrackerViewController: CardTrackerViewCellDelegate {
    func completedTracker(id: UUID,at indexPath: IndexPath) {
        do {
            try  trackerDataManager.addTrackerRecord(forId: id, date: dateFormatter.string(from: datePicker.date))
        } catch {
            showAlertController(text: "Ошибка добавления записи. Попробуйте еще раз")
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID,at indexPath: IndexPath) {
        do {
            try trackerDataManager.deleteTrackerRecord(forId: id, date: dateFormatter.string(from: datePicker.date))
        } catch {
            showAlertController(text: "Ошибка добавления записи. Попробуйте еще раз")
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
        dismiss(animated: true)
        var trackerCategory = newTracker
        let trackersSchedule = trackerCategory.trackers[0].schedule
        if trackersSchedule.isEmpty {
            guard let numberOfDay = currentDate.weekDayNumber() else { return }
            var currentDay = numberOfDay
            if numberOfDay == 1 {
                currentDay = 8
            }
            let newSchedule = WeekDay.allCases[currentDay - 2]
            let updatedTracker = Tracker(isPinned: false,
                                         id: trackerCategory.trackers[0].id,
                                         title: trackerCategory.trackers[0].title,
                                         color: trackerCategory.trackers[0].color,
                                         emoji: trackerCategory.trackers[0].emoji,
                                         schedule: (trackersSchedule) + [newSchedule])
            var updatedTrackers = trackerCategory.trackers
            updatedTrackers[0] = updatedTracker
            trackerCategory = TrackerCategory(title: trackerCategory.title, trackers: updatedTrackers)
            do {
                try trackerDataManager.addTrackerCategory(trackerCategory)
            } catch {
                showAlertController(text: "Ошибка добавления нового трекера. Попробуйте еще раз")
            }
            
        } else {
            do {
                try trackerDataManager.addTrackerCategory(trackerCategory)
            } catch {
                showAlertController(text: "Ошибка добавления нового трекера. Попробуйте еще раз")
            }
        }
        self.rlVC()
                
        // ToDo:
//                if categories.contains(where: { $0.title == trackerCategory.title}) {
//                    guard let index = categories.firstIndex(where: {$0.title == trackerCategory.title}) else { return }
//                    let oldCategory = categories[index]
//                    let updatedTrackers = oldCategory.trackers + trackerCategory.trackers
//                    let updatedTrackerByCategory = TrackerCategory(title: trackerCategory.title, trackers: updatedTrackers)
//                    categories[index] = updatedTrackerByCategory
//                } else {
//                    categories.append(trackerCategory)
//                }
//         collectionView.reloadData()
//         reloadVisibleCategories(text: searchTextField.text, date: datePicker.date)
//        reloadPlaceHolder(for: .whatToTrack)
    }
    
    private func findDiff(newCategories: [TrackerCategory]) {
        removedIndexesInSearch.removeAll()
        insertedIndexesInSearch.removeAll()
        removedSectionsInSearch.removeAll()
        insertedSectionsInSearch.removeAll()
        
        for (section, category) in visibleCatergories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !newCategories.contains(where: { $0.trackers.contains { $0.id == item.id } })
                { removedIndexesInSearch.append(IndexPath(item: index, section: section))}
            }
        }
        
        for (section, category) in newCategories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !visibleCatergories.contains(where: { $0.trackers.contains { $0.id == item.id } })
                { insertedIndexesInSearch.append(IndexPath(item: index, section: section))}
            }
        }
        
        for (section, category) in visibleCatergories.enumerated() {
            if !newCategories.contains(where: { $0.title == category.title})
            { removedSectionsInSearch.insert(section) }
        }
        
        for (section, category) in newCategories.enumerated() {
            if !visibleCatergories.contains(where: { $0.title == category.title})
            { insertedSectionsInSearch.insert(section) }
        }
    }
    
    private func performBatchUpdates() {
        if      removedSectionsInSearch.isEmpty &&
                insertedSectionsInSearch.isEmpty &&
                removedIndexesInSearch.isEmpty &&
                insertedIndexesInSearch.isEmpty
        {
            collectionView.reloadData()
        }
        
        collectionView.performBatchUpdates {
            if !removedSectionsInSearch.isEmpty {
                collectionView.deleteSections(removedSectionsInSearch)
            }
            if !insertedSectionsInSearch.isEmpty {
                collectionView.insertSections(insertedSectionsInSearch)
            }
            if !removedIndexesInSearch.isEmpty {
                collectionView.deleteItems(at: removedIndexesInSearch)
            }
            if !insertedIndexesInSearch.isEmpty {
                collectionView.insertItems(at: insertedIndexesInSearch)
            }
        }
    }
}

extension MainScreenTrackerViewController: TrackerDataManagerDelegate {
    func updateView(categories: [TrackerCategory], animating: Bool) {
        categoriesAll = categories
        visibleCatergories = categories
        
        findDiff(newCategories: categories)
        performBatchUpdates()
       
        reloadPlaceHolder(for: .notFound)
    }
    
    func updateViewByController(_ update: TrackerCategoryStoreUpdate) {
        let newCategories = trackerDataManager.categories
      
        findDiff(newCategories: newCategories)
        visibleCatergories = newCategories
        performBatchUpdates()
      
        reloadPlaceHolder(for: .whatToTrack)
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





