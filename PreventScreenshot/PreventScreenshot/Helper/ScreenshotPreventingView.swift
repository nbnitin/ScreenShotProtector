//
//  ScreenshotPreventingView.swift
//  
// Created by Nitin Bhatia on 25/4/23.
//  
//

import UIKit

public final class ScreenshotPreventingView: UIView {
    
    static var doPreventScreenShot : Bool!

    // MARK: - 📌 Constants
    // MARK: - 🔶 Properties

    public var preventScreenCapture = true {
        didSet {
            textField.isSecureTextEntry = preventScreenCapture
            ScreenshotPreventingView.doPreventScreenShot = preventScreenCapture
        }
    }

    private var contentView: UIView?
    private let textField = UITextField()

    private let recognizer = HiddenContainerRecognizer()
    private lazy var hiddenContentContainer: UIView? = try? recognizer.getHiddenContainer(from: textField)

    // MARK: - 🎨 Style
    // MARK: - 🧩 Subviews
    // MARK: - 👆 Actions
    // MARK: - 🔨 Initialization

    public init(contentView: UIView? = nil) {
        self.contentView = contentView
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 🖼 View Lifecycle

    // MARK: - 🏗 UI

    private func setupUI() {
        textField.backgroundColor = .black
        textField.isUserInteractionEnabled = false

        guard let container = hiddenContentContainer else { return }

        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        guard let contentView = contentView else { return }
        setup(contentView: contentView)

        DispatchQueue.main.async {
            // setting secure text entry in init block will fail
            // setting default value inside main thread
            self.preventScreenCapture = true
        }
    }

    // MARK: - 🚌 Public Methods

    public func setup(contentView: UIView) {
        self.contentView?.removeFromSuperview()
        self.contentView = contentView

        guard let container = hiddenContentContainer else { return }

        container.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        

        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        bottomConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: container.topAnchor),
            bottomConstraint
        ])
    }

    // MARK: - 🔒 Private Methods

}

// MARK: - 🧶 Extensions
