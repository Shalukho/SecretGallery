//
//  PhotoViewController.swift
//  SecretGallery
//
//  Created by Анастасия Шалухо on 9.07.22.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController {
    
    //MARK: - IBOutlets and properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = ImageStorage.getAllImages()
    
    let cellId = "cellImage"
    let itemCount: CGFloat = 3
    let offset: CGFloat = 2
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    @IBAction func addPhoto(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open gallery", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Open camera", style: .default, handler: { [weak self] _ in
            self?.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Add photo from URL", style: .default, handler: { [weak self] _ in
            self?.openLink()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func downloadFromURL(url: URL) {
            let downloader = ImageDownloader.default
            downloader.downloadImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.alertURL(text: "Success!")
                        self.pickedImage(value.image)
                case .failure(let error):
                    self.alertURL(text: "Error. \(error.localizedDescription)")
                }
            }
    }
    
    func alertURL(text: String) {
        let alert = UIAlertController(title: "Status", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
} 

// MARK: - Extension

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCollectionViewCell
        let image = imageArray[indexPath.item]
        cell.photo.image = image
        
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = offset * (itemCount + 1)
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemCount
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return offset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return offset
    }
}

extension PhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "No permission to gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "No permission to camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openLink() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            presentUrlAlert()
        }
    }
    
    func presentUrlAlert() {
        let alert = UIAlertController(title: "Add photo from URL", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "URL"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            guard let self = self, let text = alert.textFields?.first?.text else { return }
            if let url = URL(string: text) {
                self.downloadFromURL(url: url)
            } else {
                self.presentAlert(text: "Wrong URL")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(text: String) {
        let alert = UIAlertController(title: "Attention", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.pickedImage(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func pickedImage(_ image: UIImage) {
        imageArray += [image]
        ImageStorage.add(image)
        collectionView.reloadData()
    }
}
