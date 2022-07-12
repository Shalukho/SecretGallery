//
//  ImageStorage.swift
//  SecretGallery
//
//  Created by Анастасия Шалухо on 11.07.22.
//

import UIKit

class ImageStorage {
    static func add(_ image: UIImage?) {
        guard let image = image,
              let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = UUID().uuidString
        let faleURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else  { return }
        do {
            try data.write(to: faleURL)
            addFileName(fileName)
        } catch {
            return
        }
    }
    static func getAllImages() -> [UIImage?] {
        var images:[UIImage?] = []
        let allNames = getFileNames()
        for fileName in allNames {
            guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { continue }
            let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
            guard let savedData = try? Data(contentsOf: fileURL) else { continue }
            images.append(UIImage(data: savedData))
        }
        return images
    }
    private static func addFileName(_ filename: String) {
        let newArray = getFileNames() + [filename]
        setFileNames(newArray)
    }
    
    private static func getFileNames() -> [String] {
        guard let filenames = UserDefaults.standard.array(forKey: FileNames.filenames.rawValue) as? [String] else {return []}
        return filenames
    }
    private static func setFileNames(_ filenames:[String]) {
        UserDefaults.standard.set(filenames, forKey: FileNames.filenames.rawValue)
    }
}
fileprivate enum FileNames: String {
    case filenames
}
