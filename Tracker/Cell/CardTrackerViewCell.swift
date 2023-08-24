//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 22.06.2023.
//

import UIKit
// MARK: - Protocols
protocol CardTrackerViewCellDelegate: AnyObject  {
    func completedTracker(id: UUID, at indexPath: IndexPath)
    func uncompletedTracker(id: UUID, at indexPath: IndexPath)
}

protocol ContextMenuInteractionDelegate: AnyObject {
    func contextMenuConfiguration(at indexPath: IndexPath) -> UIContextMenuConfiguration?
}

// MARK: - CollectionViewCell class
final class CardTrackerViewCell: UICollectionViewCell {
    static let cardTrackerViewCellIdentifier = "CardTrackerCollectionViewIdentifier"
    
    // MARK: - Properties
    
    private  let cardTrackerView: UIView = {
        let cardTrackerView = UIView()
        cardTrackerView.layer.cornerRadius = 16
        cardTrackerView.layer.masksToBounds = true
        cardTrackerView.translatesAutoresizingMaskIntoConstraints = false
        return cardTrackerView
    }()
    
    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.clipsToBounds = true
        emojiLabel.layer.cornerRadius = 24 / 2
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.backgroundColor = .EmojiBackGround
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private  let cardTrackerText: UILabel = {
        let cardTrackerText = UILabel()
        cardTrackerText.textColor = .WhiteDay
        cardTrackerText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        cardTrackerText.translatesAutoresizingMaskIntoConstraints = false
        return cardTrackerText
    }()
    
    private lazy var pinImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"pinImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var counterDaysLabelText: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus")
        button.tintColor = .WhiteDay
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 34 / 2
        button.addTarget(nil, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contextMenuInteraction: UIContextMenuInteraction = {
        let interaction = UIContextMenuInteraction(delegate: self)
        return interaction
    }()
    
    private var isCompletedToday: Bool = false
    weak var delegate:CardTrackerViewCellDelegate?
    weak var contextMenuDelegate: ContextMenuInteractionDelegate?
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var currentDate: Date =  Date()
    private var date: Date = Date()
    
    func configure(with model: CardTrackerViewModel) {
        self.trackerID = model.tracker.id
        self.isCompletedToday = model.isCompletedToday
        self.indexPath = model.indexPath
        self.currentDate = model.currentDate
        let color = model.tracker.color
        addCardViews()
        setupConstraints()
        cardTrackerView.backgroundColor = color
        plusButton.backgroundColor = color
        cardTrackerText.text = model.tracker.title
        emojiLabel.text = model.tracker.emoji
        let wordDay = pluralizeDays(model.completedDays)
        counterDaysLabelText.text = "\(wordDay)"
        let image = isCompletedToday ? doneImage : plusImage
        plusButton.setImage(image, for: .normal)
        self.pinImageView.isHidden = model.tracker.isPinned ? false : true
        cardTrackerView.addInteraction(contextMenuInteraction)
    }
    private func addCardViews() {
        contentView.addSubview(cardTrackerView)
        cardTrackerView.addSubview(emojiLabel)
        cardTrackerView.addSubview(pinImageView)
        cardTrackerView.addSubview(cardTrackerText)
        contentView.addSubview(plusButton)
        contentView.addSubview(counterDaysLabelText)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardTrackerView.topAnchor.constraint(equalTo: topAnchor),
            cardTrackerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardTrackerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardTrackerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.leadingAnchor.constraint(equalTo: cardTrackerView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: cardTrackerView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            pinImageView.heightAnchor.constraint(equalToConstant: 12),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            pinImageView.topAnchor.constraint(equalTo: cardTrackerView.topAnchor, constant: 18),
            pinImageView.trailingAnchor.constraint(equalTo: cardTrackerView.trailingAnchor, constant: -12),
            
            
            cardTrackerText.leadingAnchor.constraint(equalTo: cardTrackerView.leadingAnchor, constant: 12),
            cardTrackerText.trailingAnchor.constraint(equalTo: cardTrackerView.trailingAnchor, constant: -12),
            cardTrackerText.bottomAnchor.constraint(equalTo: cardTrackerView.bottomAnchor, constant: -12),
            
            plusButton.topAnchor.constraint(equalTo: cardTrackerView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: cardTrackerView.trailingAnchor, constant: -12),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterDaysLabelText.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            counterDaysLabelText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    @objc private func plusButtonTapped() {
        guard let trackerID = trackerID, let indexPath = indexPath else { return assertionFailure(" no id Tracker")}
        
            if isCompletedToday {
                delegate?.uncompletedTracker(id: trackerID, at: indexPath)
            } else {
                delegate?.completedTracker(id: trackerID, at: indexPath)
            }
        
    }
    
    private func pluralizeDays(_ count: Int) -> String {
        let localizedCompletedDayz = NSLocalizedString("completedDays", comment: "Number of completed days")
        return String.localizedStringWithFormat(localizedCompletedDayz, count)
    }
    
    
    private let plusImage: UIImage = {
        let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize) ?? UIImage()
        return image
    }()
    
    private let doneImage = UIImage(named: "done")
}

extension CardTrackerViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let indexPath else { return nil }
        return contextMenuDelegate?.contextMenuConfiguration(at: indexPath)
    }
}


struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
