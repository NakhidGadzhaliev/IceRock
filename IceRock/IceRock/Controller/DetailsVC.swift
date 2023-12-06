import UIKit
import SnapKit

final class DetailsVC: UIViewController {
    private var image: ImageModel?
    private var otherImages: [ImageModel] = [ImageModel]()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = (view.frame.width / 7) - 1
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            GalleryCollectionViewCell.self,
            forCellWithReuseIdentifier: R.string.constants.galleryCollectionViewCellId()
        )
        
        return collectionView
    }()
    
    private lazy var size = view.frame.width
    
    init(generalImage: ImageModel, otherImages: [ImageModel]) {
        super.init(nibName: nil, bundle: nil)
        self.image = generalImage
        self.otherImages = otherImages
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUpdate()
        pinchToZoom()
        collectionView.dataSource = self
    }
}

// MARK: - Methods
private extension DetailsVC {
    func getDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(image?.date ?? 0))
        return DateFormatter.titleDateFormatter.string(from: date)
    }
    
    func viewUpdate() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(collectionView)
        navBarConfiguration()
        setupConstraints()
        imageView.kf.setImage(with: URL(string: image?.urlString ?? String.empty), placeholder: UIImage(systemName: "photo"))
    }
    
    func setupConstraints() {
        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: size,
            height: size
        )
        imageView.center = view.center
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width / 7)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    func navBarConfiguration() {
        title = getDate()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        navigationController?.navigationItem.hidesBackButton = true //
        navigationController?.navigationBar.tintColor = R.color.customBlack()
    }
    
    func pinchToZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
        imageView.addGestureRecognizer(pinchGesture)
    }
    
}

// MARK: - Actions
private extension DetailsVC {
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            imageView.frame = CGRect(x: 0, y: 0, width: size  * scale, height: size * scale)
            imageView.center = view.center
        }
        if gesture.state == .ended {
            imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
            imageView.center = view.center
        }
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            let alert = UIAlertController(
                title: R.string.localizable.error(),
                message: R.string.localizable.imageNotFound(),
                preferredStyle: .alert
            )
            let actionOK = UIAlertAction(title: R.string.localizable.ok(), style: .default)
            alert.addAction(actionOK)
            self.present(alert, animated: true)
            return
        }
        
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, error in
            
            if bool {
                let alert = UIAlertController(
                    title: R.string.localizable.saved(),
                    message: R.string.localizable.imageSuccessfullySavedToGallery(),
                    preferredStyle: .alert
                )
                let actionOK = UIAlertAction(title: R.string.localizable.ok(), style: .default)
                alert.addAction(actionOK)
                self.present(alert, animated: true)
            }
            
            if error != nil {
                let alert = UIAlertController(
                    title: R.string.localizable.error(),
                    message: R.string.localizable.someErrorDuringExecution(),
                    preferredStyle: .alert
                )
                let actionOK = UIAlertAction(title: R.string.localizable.ok(), style: .default)
                alert.addAction(actionOK)
                self.present(alert, animated: true)
            }
        }
        
        present(shareController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        otherImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: R.string.constants.galleryCollectionViewCellId(),
            for: indexPath
        ) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let url = otherImages[indexPath.row].urlString
        cell.configure(with: url)
        return cell
    }
}
