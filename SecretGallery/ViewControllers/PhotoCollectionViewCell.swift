//
//  PhotoCollectionViewCell.swift
//  SecretGallery
//
//  Created by Анастасия Шалухо on 9.07.22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
   
    //MARK: - IBOutlets
    @IBOutlet weak var photo: UIImageView!
    
    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setup(for image: UIImage) {
        self.photo.image = image
        self.photo.contentMode = .scaleAspectFill
    }
}
