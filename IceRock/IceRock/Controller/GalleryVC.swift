import UIKit
import SnapKit

final class GalleryVC: UIViewController {
    private var imagesArray: [ImageModel] = [ImageModel]()
    
    private lazy var galleryCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = (view.frame.width / 2) - 1
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            GalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: R.string.constants.galleryCollectionViewCellId()
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdate()
        fetchData()
    }
}

// MARK: - Methods
private extension GalleryVC {
    func viewUpdate() {
        view.backgroundColor = .systemBackground
        view.addSubview(galleryCollectionView)
        navBarConfiguration()
        setupConstraints()
        collectionViewConfiguration()
    }
    
    func fetchData() {
        APIManager.shared.getImages { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self?.imagesArray = images
                    self?.galleryCollectionView.reloadData()
                case .failure:
                    self?.showErrorAlert()
                }
            }
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: R.string.localizable.failedLoadingImages(),
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: R.string.localizable.reload(),
            style: .default,
            handler: { [weak self] (_) in
                self?.fetchData()
            })
        )
        
        present(alert, animated: true)
    }
    
    func collectionViewConfiguration() {
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
    }
    
    func navBarConfiguration() {
        title = R.string.localizable.gallery()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: R.string.localizable.logout(),
            style: .done,
            target: self,
            action: #selector(exitButtonTapped)
        )
        navigationController?.navigationBar.tintColor = R.color.customBlack()
    }
    
    func setupConstraints() {
        galleryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Actions
private extension GalleryVC {
    @objc func exitButtonTapped() {
        let alert = UIAlertController(title: R.string.localizable.logout() + String.question, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.no(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: R.string.localizable.yes(), style: .default, handler: { [weak self] _ in
            
            AuthManager.shared.logOut { success in
                if success {
                    DispatchQueue.main.async {
                        let loginVC = LoginVC()
                        loginVC.modalPresentationStyle = .fullScreen
                        self?.present(loginVC, animated: true)
                    }
                }
            }
            
        }))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imagesArray[indexPath.row]
        let otherImages = imagesArray.filter { $0.id != image.id }
        let detailVC = DetailsVC(generalImage: image, otherImages: otherImages)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: R.string.constants.galleryCollectionViewCellId(),
            for: indexPath
        ) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let url = imagesArray[indexPath.row].urlString
        cell.configure(with: url)
        
        return cell
    }
}
