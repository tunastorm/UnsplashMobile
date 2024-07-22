//
//  PhotoManager.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

final class PhotoManager: FileManager {
    
    private var documentDirectory: URL?

    override init() {
        self.documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
        // document 위치 할당
        guard let documentDirectory else { return }
        
        //이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let documentDirectory else { return nil }
             
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이 경로에 실제로 파일이 존재하는 지 확인
        var path: String?
        if #available(iOS 16.0, *) {
            path = fileURL.path()
        } else {
            path = fileURL.path
        }
        
        if let path, FileManager.default.fileExists(atPath: path) {
            return UIImage(contentsOfFile: path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    func removeImageFromDocument(filename: String) -> Bool? {
        guard let documentDirectory else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        var path: String?
        if #available(iOS 16, *) {
            path = fileURL.path()
        } else {
            path = fileURL.path
        }
        
        if let path, FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                return true
            } catch {
                print(#function, "file remove error", error)
                return false
            }
        } else {
            return nil
            print("file no exist")
        }
    }
}
