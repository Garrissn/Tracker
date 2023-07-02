//
//  ViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 21.06.2023.
//

import UIKit

class MainScreenTrackerViewController: UIViewController {
    
    

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CardTrackerViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
 
    
//    private let headerView: UIView = {
//        let headerView = UIView()
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        return headerView
//    }()
    
//    private lazy var plusButton: UIButton = {
//        let plusButton = UIButton()
//        plusButton.setImage(UIImage(named: "PlusButton"), for: .normal)
//        plusButton.translatesAutoresizingMaskIntoConstraints = false
//        plusButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
//        return plusButton
//    }()
    
//    private let errorImage: UIImageView = {
//        let image = UIImage(named: "error")
//        let errorImage = UIImageView(image: image)
//        errorImage.translatesAutoresizingMaskIntoConstraints = false
//        return errorImage
//    }()
    
    private let placeholderView = PlaceholderView()
    

    
//    private let titleHeader: UILabel = {
//        let label = UILabel ()
//        label.text = "Трекеры"
//        label.textColor = .BlackDay
//        label.font = UIFont(name: "SP-Pro", size: 34)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    private lazy var dateLabel: UILabel = {
//        let dateLabel = UILabel ()
//        dateLabel.backgroundColor = .BackGroundDay
//        dateLabel.font = UIFont(name: "SP-Pro", size: 17)
//        dateLabel.textAlignment = .center
//        dateLabel.textColor = .black
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel.clipsToBounds = true
//        dateLabel.layer.cornerRadius = 8
//        dateLabel.layer.zPosition = 10
//        return dateLabel
//    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .Blue
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    
    
//    private let searchStackview: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.distribution = .fill
//        stack.spacing = 14
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
    
    
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .BackGroundDay
        textField.layer.cornerRadius = 16
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributedPlaceHolder = NSAttributedString(string: "Поиск", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceHolder
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        textField.textColor = .Gray
        textField.font = UIFont(name: "SP-Pro", size: 17)
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
        filterButton.setTitle("Фильтры", for: .normal)
        filterButton.backgroundColor = .blue
        filterButton.titleLabel?.font = UIFont(name: "SP-Pro", size: 17)
        filterButton.tintColor = .white
        filterButton.addTarget(self, action: #selector(selectFilterTapped), for: .touchUpInside)
        filterButton.layer.cornerRadius = 16
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.isHidden = true
        return filterButton
    }()
    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9)
    
    private var categories: [TrackerCategory] = [] //список категорий и вложенных в них трекеров
    private var completedTrackers: [TrackerRecord] = [] // трекуры выполненные в выбранную дату
    private var currentDate: Date
    private let dataManager = DataManager.shared
    private var visibleCatergories: [TrackerCategory] = [] // массив который пользователь увидит после фильтр
   
    init() {
        currentDate = Date()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        addViews()
        setupCollectionView()
        setupConstraints()
        configureView()
        setupNavigationBar()
    }
    
    private func configureView() {
        view.backgroundColor = .WhiteDay
        searchTextField.returnKeyType = .done
        filterButton.layer.zPosition = 2
    }
    private func reloadData() {
        
        categories = dataManager.categories  // mock
        visibleCatergories = categories
        dateChanged()
    }
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }

    private func addViews() {
       
        view.addSubview(searchTextField)
        view.addSubview(placeholderView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)

    }

    private func setupConstraints() {

    NSLayoutConstraint.activate([

        
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
        searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        
        placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        placeholderView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor,constant: 220),
        

        
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
        filterButton.heightAnchor.constraint(equalToConstant: 50),
        filterButton.widthAnchor.constraint(equalToConstant: 114),
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    private func updateLabelTitle( with date: Date) {
        let dateString = formattedDate(from: date)
       // dateLabel.text = dateString
    }
    
    @objc private func addTask() {

        let trackerTypeSelectionViewController = TrackerTypeSelectionViewController()
        //trackerTypeSelectionViewController.updateDelegate = self
        let navVC = UINavigationController(rootViewController: trackerTypeSelectionViewController)
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged() {
        updateLabelTitle(with: datePicker.date)
        reloadVisibleCategories(text: searchTextField.text, date: datePicker.date)
    }
    
    @objc private func  selectFilterTapped() {
       print("filter Tapped")
    }
    
    private func  setupNavigationBar() {
        
        if let navBar = navigationController?.navigationBar {
                    let imageButton = UIImage(named: "PlusButton")
                    let button = UIButton(type: .custom)
                    button.setImage(imageButton, for: .normal)
                    button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
                  
                    let leftButton = UIBarButtonItem(customView: button)
                    navBar.topItem?.setLeftBarButton(leftButton, animated: true)
                    
                    let rightButton = UIBarButtonItem(customView: datePicker)
                    navBar.topItem?.setRightBarButton(rightButton, animated: true)
                       navigationItem.title = "Трекеры"
                       navigationController?.navigationBar.prefersLargeTitles = true
                       
                   }
        
    }
    
    private func reloadVisibleCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        let filterText = (text ?? " ").lowercased()
        
        visibleCatergories = categories.compactMap { category in
            
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.title.lowercased().contains(filterText)
                let dateCondition =
                tracker.schedule?.contains { weekDay in
                    
                     weekDay.numberValue == filterWeekday
                    
                } == true
                return textCondition && dateCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        }

        collectionView.reloadData()
        reloadPlaceHolder()
    }
    private func reloadPlaceHolder() {
        placeholderView.isHidden = !categories.isEmpty
    }

}


extension MainScreenTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories(text: searchTextField.text, date: datePicker.date)
        return true
    }
}

extension MainScreenTrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCatergories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = visibleCatergories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else { return UICollectionReusableView()}
        
        let titleCategory = visibleCatergories[indexPath.section].title
        view.configureHeader(title: titleCategory)
        return view
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardTrackerViewCell else { return UICollectionViewCell() }
        let cellData = visibleCatergories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
       
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.trackerId == tracker.id
        }.count
        cell.configure(with: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, indexPath: indexPath)

        return cell
    }
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
            
        }
    }
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
       return  trackerRecord.trackerId == id && isSameDay
    }
}

extension MainScreenTrackerViewController: CardTrackerViewCellDelegate {
    func completedTracker(id: UUID,at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerId: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompletedTracker(id: UUID,at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

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
        
        return CGSize(width: cellWidth, height: 132)
    }
    
}




struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}
struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}

enum WeekDay {
    case monday,tuesday,wednesday,thursday,friday,saturday,sunday
    var numberValue: Int {
            switch self {
            
            case .monday: return 1
            case .tuesday: return 2
            case .wednesday: return 3
            case .thursday: return 4
            case .friday: return 5
            case .saturday: return 6
            case .sunday: return 7
            }
        }
    
    var stringValue: String {
          switch self {
          case .monday: return "Понедельник"
          case .tuesday: return "Вторник"
          case .wednesday: return "Среда"
          case .thursday: return "Четверг"
          case .friday: return "Пятница"
          case .saturday: return "Суббота"
          case .sunday: return "Воскресенье"
          }
      }
    
    var shortValue: String {
            switch self {
            case .monday: return "Пн"
            case .tuesday: return "Вт"
            case .wednesday: return "Ср"
            case .thursday: return "Чт"
            case .friday: return "Пт"
            case .saturday: return "Сб"
            case .sunday: return "Вс"
            }
        }
    
}
