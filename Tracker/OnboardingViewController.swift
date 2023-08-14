//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 08.08.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private lazy var pages: [UIViewController] = {
        let firstPage = setupFirstPage()
        firstPage.view.backgroundColor = .clear
        let secondPage = setupSecondPage()
        secondPage.view.backgroundColor = .clear
        return [firstPage, secondPage]
    }()
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        let firstImage = UIImage(named: "onboardFirstScreen")
        imageView.image = firstImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        let secondImage = UIImage(named: "onboardSecondScreen")
        imageView.image = secondImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.numberOfPages = pages.count
        pageControll.currentPage = 0
        pageControll.currentPageIndicatorTintColor = .BlackDay
        pageControll.pageIndicatorTintColor = UIColor.BlackDay.withAlphaComponent(0.3)
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        return pageControll
    }()
    
    private let firstPageLabel: UILabel = {
        let label = UILabel()
        label.text = "Отслеживайте только то, что хотите"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .BlackDay
        label.font = UIFont.ypBold32()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondPageLabel: UILabel = {
        let label = UILabel()
        label.text = "Даже если это не литры воды и йога"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .BlackDay
        label.font = UIFont.ypBold32()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var onboardingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .BlackDay
        button.titleLabel?.font = UIFont.ypMedium16()
        button.tintColor = .WhiteDay
        
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(onboardingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(transitionStyle: UIPageViewController.TransitionStyle,
                 navigationOrientation: UIPageViewController.NavigationOrientation,
                 options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraints()
        delegate = self
        dataSource = self
    }
    
    private func addViews() {
        view.addSubview(pageControl)
        view.addSubview(onboardingButton)
    }
    
    private func  addConstraints() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 638),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            onboardingButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            onboardingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
                        onboardingButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    private func setupFirstPage() -> UIViewController {
        let firstPage = UIViewController()
        firstPage.view.addSubview(firstImageView)
        firstImageView.addSubview(firstPageLabel)
        firstImageView.addSubview(onboardingButton)
        
        NSLayoutConstraint.activate([
            firstImageView.topAnchor.constraint(equalTo: firstPage.view.topAnchor),
            firstImageView.leadingAnchor.constraint(equalTo: firstPage.view.leadingAnchor),
            firstImageView.trailingAnchor.constraint(equalTo: firstPage.view.trailingAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: firstPage.view.bottomAnchor),
            
            firstPageLabel.topAnchor.constraint(equalTo: firstImageView.topAnchor, constant: 432),
            firstPageLabel.leadingAnchor.constraint(equalTo: firstImageView.leadingAnchor, constant: 16),
            firstPageLabel.trailingAnchor.constraint(equalTo: firstImageView.trailingAnchor, constant: -16),
          
            onboardingButton.topAnchor.constraint(equalTo: firstPageLabel.bottomAnchor, constant: 24),
            onboardingButton.leadingAnchor.constraint(equalTo: firstImageView.leadingAnchor, constant: 20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
            onboardingButton.widthAnchor.constraint(equalToConstant: 335)
        ])
        return firstPage
    }
    
    private func setupSecondPage() -> UIViewController {
        let secondPage = UIViewController()
        secondPage.view.addSubview(secondImageView)
        secondImageView.addSubview(secondPageLabel)
        secondImageView.addSubview(onboardingButton)
        
        NSLayoutConstraint.activate([
            secondImageView.topAnchor.constraint(equalTo: secondPage.view.topAnchor),
            secondImageView.leadingAnchor.constraint(equalTo: secondPage.view.leadingAnchor),
            secondImageView.trailingAnchor.constraint(equalTo: secondPage.view.trailingAnchor),
            secondImageView.bottomAnchor.constraint(equalTo: secondPage.view.bottomAnchor),
            
            secondPageLabel.topAnchor.constraint(equalTo: secondImageView.topAnchor, constant: 388),
            secondPageLabel.leadingAnchor.constraint(equalTo: secondImageView.leadingAnchor, constant: 16),
            secondPageLabel.trailingAnchor.constraint(equalTo: secondImageView.trailingAnchor, constant: -16),
                        
            onboardingButton.topAnchor.constraint(equalTo: secondPageLabel.bottomAnchor, constant: 24),
            onboardingButton.leadingAnchor.constraint(equalTo: secondImageView.leadingAnchor, constant: 20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
            onboardingButton.widthAnchor.constraint(equalToConstant: 335)
        ])
        
        return secondPage
    }
    
    @objc private func  onboardingButtonTapped() {
        let tabbar = TabBarController()
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
               window.rootViewController = tabbar
               window.makeKeyAndVisible()
           
        present(tabbar, animated: true, completion: nil)
    }
}

extension OnboardingViewController:  UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let curVC = pageViewController.viewControllers?.first,
           let curIndex = pages.firstIndex(of: curVC) {
            pageControl.currentPage = curIndex
        }
    }
}

private enum Constants {
    static let firstPageTitle = NSLocalizedString("onboardingFirstLabelTitle", comment: "Title of the first onboarding page")
    static let secondPageTitle = NSLocalizedString(
        "onboardingSecondLabel.title",
        comment: "Title of the second onboarding page"
    )
    static let trackersScreenButtonTitle = NSLocalizedString(
        "button.onboarding.title",
        comment: "Title of the button that switches to tracker screen"
    )
}
