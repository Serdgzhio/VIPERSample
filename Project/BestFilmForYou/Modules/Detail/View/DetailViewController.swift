//
//  DetailDetailViewController.swift
//  BestFilmForYou
//
//  Created by Azarenkov Sergey on 04/12/2020.
//  Copyright 2020 CHISW. All rights reserved.
//


import UIKit

final class DetailViewController: UIViewController, Viewable, Origin {
  typealias State = DetailViewState
  typealias Output = DetailViewOutput
  var output: Output!
  
  lazy var saveButton: UIBarButtonItem = {
    let view = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(saveButtonDidTap))
    return view
  }()
  
  lazy var segment: UISegmentedControl = {
    let view = UISegmentedControl()
    return view
  }()
  
  lazy var titleLabel: UILabel = {
    let view = UILabel()
    view.textAlignment = .center
    view.numberOfLines = 2
    return view
  }()
  
  lazy var descriptionLabel: UILabel = {
    let view = UILabel()
    view.textAlignment = .center
    view.numberOfLines = 0
    return view
  }()
  
  lazy var progress: UIProgressView = {
    let view = UIProgressView(progressViewStyle: .default)
    view.tintColor = .green
    return view
  }()
  
  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    output.readyForInitState()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    output.willAppear()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    output.willDisappear()
  }
  
  func setupView() {
    view.backgroundColor = .white
    view.addSubview(imageView)
    view.addSubview(titleLabel)
    view.addSubview(descriptionLabel)
    view.addSubview(progress)
    view.addSubview(segment)
    
    navigationItem.rightBarButtonItem = saveButton
    
    segment.translatesAutoresizingMaskIntoConstraints = false
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    progress.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      segment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      segment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      imageView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 10),
      imageView.leadingAnchor.constraint(equalTo: segment.leadingAnchor, constant: 16),
      imageView.trailingAnchor.constraint(equalTo: segment.trailingAnchor, constant: -16),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
      
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      progress.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
      progress.heightAnchor.constraint(equalToConstant: 10),
      progress.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      progress.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      progress.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -16)
    ])
  }
  
  @objc func saveButtonDidTap() {
    output.saveDidTap(selectedIndex: segment.selectedSegmentIndex)
  }
  
  func applyState(_ state: State) {
    switch state{
    case let .initial(segments: segments, image: image, viewModel: viewModel, reactionIndex: index):
      segments.enumerated().forEach({ item in
        segment.insertSegment(withTitle: item.element, at: item.offset, animated: false)
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
      })
      segment.selectedSegmentIndex = index
      descriptionLabel.text = viewModel.description
      titleLabel.text = viewModel.title
      imageView.image = image.image
    case let .saveButtonEnable(buttonText):
      saveButton.title = buttonText
    case let .setNavBarHidden(isHidden):
      navigationController?.isNavigationBarHidden = isHidden
    }
  }
  
  @objc func segmentChanged() {
    output.segmentChanged(index: segment.selectedSegmentIndex)
  }
}

extension DetailViewController: Constructable {
  static func construct(output: Output) -> DetailViewController {
    let vc = DetailViewController()
    vc.output = output
    return vc
  }
}

extension DetailViewController: DetailViewInput {}

extension DetailViewController: Storyboardable {}
