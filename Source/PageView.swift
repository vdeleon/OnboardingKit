//
//  PageView.swift
//  Athlee-Onboarding
//
//  Created by mac on 06/07/16.
//  Copyright © 2016 Athlee. All rights reserved.
//

import UIKit

public protocol Configurable {
  associatedtype Configuration
  func configure(configuration: Configuration)
}

public final class PageView: UIView {
  
  // MARK: Properties
  
  public var configuration: OnboardingConfiguration! { didSet { configure(configuration) } }
  
  private let topStackView = UIStackView()
  private let bottomStackView = UIStackView()
  
  public var image: UIImage = UIImage() { didSet { imageView.image = image } }
  public var pageTitle: String = "" { didSet { titleLabel.text = pageTitle } }
  public var pageDescription: String = "" { didSet { descriptionLabel.text = pageDescription } }
  
  public lazy var imageView = UIImageView()
  public lazy var titleLabel = UILabel()
  public lazy var descriptionLabel = UILabel()
  
  public var backgroundImage: UIImage = UIImage() { didSet { backgroundImageView.image = backgroundImage } }
  public var bottomBackgroundImage: UIImage = UIImage() { didSet { bottomBackgroundImageView.image = bottomBackgroundImage } }
  public var topBackgroundImage: UIImage = UIImage() { didSet { topBackgroundImageView.image = topBackgroundImage } }
  
  private var backgroundImageView = UIImageView()
  private var topBackgroundImageView = UIImageView()
  private var bottomBackgroundImageView = UIImageView()
  
  public var topContainerOffset: CGFloat = 8 { didSet { topContainerAnchor.constant = topContainerOffset } }
  public var bottomContainerOffset: CGFloat = 8 { didSet { bottomContainerAnchor.constant = bottomContainerOffset } }
  
  public var offsetBetweenContainers: CGFloat = 8 {
    didSet {
      topContainerHeightAnchor.constant = -topContainerOffset - offsetBetweenContainers / 2
      bottomContainerHeightAnchor.constant = -bottomContainerOffset - offsetBetweenContainers / 2
    }
  }
  
  private var topContainerAnchor: NSLayoutConstraint!
  private var bottomContainerAnchor: NSLayoutConstraint!
  private var topContainerHeightAnchor: NSLayoutConstraint!
  private var bottomContainerHeightAnchor: NSLayoutConstraint!
  
  // MARK: Life cycle 
  
  public init() {
    super.init(frame: .zero)
    setup()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup 
  
  private func setup() {
    addSubview(topStackView)
    addSubview(bottomStackView)
    
    setupTopStackView()
    setupBottomStackView()
    addBackgroundImageViews()
  }
  
  private func addBackgroundImageViews() {
    setupBackgroundImageView()
    setupTopBackgroundImageView()
    setupBottomBackgroundImageView()
  }
  
  private func setupBackgroundImageView() {
    insertSubview(backgroundImageView, atIndex: 0)
    
    backgroundImageView.opaque = true
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false 
    backgroundImageView.contentMode = .ScaleAspectFill
    backgroundImageView.image = backgroundImage
    
    let backgroundAnchors = [
      backgroundImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      backgroundImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
      backgroundImageView.topAnchor.constraintEqualToAnchor(topAnchor),
      backgroundImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(backgroundAnchors)
  }
  
  private func setupTopBackgroundImageView() {
    insertSubview(topBackgroundImageView, atIndex: 1)
    
    topBackgroundImageView.opaque = true
    topBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    topBackgroundImageView.contentMode = .ScaleToFill
    topBackgroundImageView.image = topBackgroundImage
    
    let bottomBackgroundAnchors = [
      topBackgroundImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      topBackgroundImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
      topBackgroundImageView.topAnchor.constraintEqualToAnchor(topAnchor),
      topBackgroundImageView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 0.5)
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(bottomBackgroundAnchors)
  }
  
  private func setupBottomBackgroundImageView() {
    insertSubview(bottomBackgroundImageView, atIndex: 1)
    
    bottomBackgroundImageView.opaque = true
    bottomBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    bottomBackgroundImageView.contentMode = .ScaleToFill
    bottomBackgroundImageView.image = bottomBackgroundImage
    
    let bottomBackgroundAnchors = [
      bottomBackgroundImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      bottomBackgroundImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
      bottomBackgroundImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
      bottomBackgroundImageView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 0.5)
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(bottomBackgroundAnchors)
  }
  
  private func setupTopStackView() {
    // Top StackView layout setup
    topStackView.translatesAutoresizingMaskIntoConstraints = false
    
    topContainerAnchor = topStackView.topAnchor.constraintEqualToAnchor(topAnchor, constant: topContainerOffset)!
    topContainerHeightAnchor = topStackView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 0.5, constant: -topContainerOffset - offsetBetweenContainers / 2)!
    
    let topAnchors = [
      topStackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: topContainerOffset),
      topStackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -topContainerOffset),
      topContainerAnchor,
      topContainerHeightAnchor
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(topAnchors)
    
    // StackViews common setup
    topStackView.axis = .Vertical
    topStackView.alignment = .Center
    topStackView.distribution = .Fill
    topStackView.spacing = -10 // TODO: Make inspectable
    
    // Add subviews to the top StackView
    topStackView.addArrangedSubview(imageView)
    topStackView.addArrangedSubview(titleLabel)
    
    // Intial setup for top StackView subviews
    imageView.opaque = true 
    imageView.contentMode = .ScaleAspectFit
    titleLabel.font = UIFont.boldSystemFontOfSize(35)
    titleLabel.textAlignment = .Center
    titleLabel.text = pageTitle
    //titleLabel.backgroundColor = .redColor()
    
    // This way the StackView knows how to size & align subviews.
    imageView.setContentHuggingPriority(250, forAxis: .Vertical)
    titleLabel.setContentHuggingPriority(252, forAxis: .Vertical)
  }
  
  private func setupBottomStackView() {
    // Bottom StackView layout setup
    bottomStackView.translatesAutoresizingMaskIntoConstraints = false
    
    bottomContainerAnchor = bottomStackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -bottomContainerOffset)!
    bottomContainerHeightAnchor = bottomStackView.heightAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 0.5, constant: -bottomContainerOffset - offsetBetweenContainers / 2)!
    
    let bottomAnchors = [
      bottomStackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: bottomContainerOffset),
      bottomStackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -bottomContainerOffset),
      bottomContainerAnchor,
      bottomContainerHeightAnchor
      ].flatMap { $0 }
    
    NSLayoutConstraint.activateConstraints(bottomAnchors)
    
    // StackViews common setup
    bottomStackView.axis = .Vertical
    bottomStackView.alignment = .Center
    bottomStackView.distribution = .Fill
    bottomStackView.spacing = 0 // TODO: Make inspectable 
    
    // Add subviews to the bottom StackView
    bottomStackView.addArrangedSubview(descriptionLabel)
    
    // Intial setup for top StackView subviews
    descriptionLabel.font = UIFont.systemFontOfSize(17)
    descriptionLabel.textAlignment = .Center
    descriptionLabel.text = pageDescription
    descriptionLabel.numberOfLines = 0
    //descriptionLabel.backgroundColor = .orangeColor()
  }
  
}

// MARK: - Configurable 

extension PageView: Configurable {
  public func configure(configuration: OnboardingConfiguration) {
    image = configuration.image
    pageTitle = configuration.pageTitle
    pageDescription = configuration.pageDescription
    
    if let backgroundImage = configuration.backgroundImage {
      self.backgroundImage = backgroundImage
    }
    
    if let bottomBackgroundImage = configuration.bottomBackgroundImage {
      self.bottomBackgroundImage = bottomBackgroundImage
    }
  }
}
