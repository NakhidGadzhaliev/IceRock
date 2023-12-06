import UIKit
import Kingfisher
import SnapKit

class GalleryCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure()
    }
}

// MARK: - Methods
extension GalleryCollectionViewCell {
    func configure(with imageUrl: String) {
        let url = URL(string: imageUrl)
        let placeholderImage = UIImage(systemName: "photo")?.withRenderingMode(.alwaysOriginal)
        imageView.kf.setImage(with: url, placeholder: placeholderImage)
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
