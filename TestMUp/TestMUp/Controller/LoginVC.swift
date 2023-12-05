//
//  LoginVC.swift
//  TestMUp
//
//  Created by Нахид Гаджалиев on 27.04.2023.
//

import UIKit
import SnapKit

final class LoginVC: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.photoGallery()
        label.font = .systemFont(ofSize: 44, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.logInWithVK(), for: .normal)
        button.setTitleColor(R.color.customWhite(), for: .normal)
        button.backgroundColor = R.color.customBlack()
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdate()
    }
}

// MARK: - Methods
private extension LoginVC {
    func viewUpdate() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(view.frame.height * 0.2)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func authErrorAlert() {
        let title = R.string.localizable.error()
        let message = R.string.localizable.someErrorDuringAuthorization()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))

        present(alert, animated: true)
    }
}

// MARK: - Actions
private extension LoginVC {
    @objc func loginButtonTapped() {
        let authVC = AuthorizationVC()
        
        authVC.authorizationCompletion = { [weak self] success in
            switch success {
            case true:
                let galleryVC = GalleryVC()
                let navVC = UINavigationController(rootViewController: galleryVC)
                navVC.modalPresentationStyle = .fullScreen
                self?.present(navVC, animated: true)
            case false:
                self?.authErrorAlert()
            }
        }
        
        present(authVC, animated: true)
    }
}
