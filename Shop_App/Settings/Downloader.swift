//
//  Downloader.swift
//  Shop_App
//
//  Created by Demo on 8.02.2019.
//  Copyright © 2019 Demo. All rights reserved.
//

import Foundation
import Firebase

var storage = Storage.storage()

func downloadImages(urls: String, withBlock: @escaping(_ image: [UIImage?])->Void) {
    
    // linkleri ayırma işlemi yapılıyor.
    let linkArray = seperateImageLinks(allLinks: urls)
    var imageArray: [UIImage] = []
    
    var downloadCount = 0
    
    for link in linkArray {
        
        // her bir link için url oluşturuluyır.
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
    
        downloadQueue.async {
            downloadCount += 1
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                
                
                imageArray.append(UIImage(data: data! as Data)!)
                
                if downloadCount == imageArray.count {
                    
                    DispatchQueue.main.async {
                        withBlock(imageArray)
                    }
                }
            } else {
                print("image dosyaları indirilemedi")
                withBlock(imageArray)
            }
            
        }
        
        
    }
    
    
}
// firebase e image verilerini kaydetmek için resim dosyalrından "data file" formatına dönüştürülmeli
func uploadImages(images: [UIImage], userID: String, referenceNumber: String, withBlock: @escaping (_ imageLink: String?)->Void) {
    
    // burada image türünde dosya göndereceğim data türünde veri alacağım
    convertImagesToData(images: images) { (pictures) in
        
        var uploadCounter = 0
        var nameSuffix = 0
        var linkString = ""
        
        for picture in pictures {
            
            let fileName = "PropertyImages/" + userID + "/" + referenceNumber + "/image" + "\(nameSuffix)" + ".jpg"
            
            nameSuffix += 1
           
            // Firebase storage kısmında bir "referans: gs://shopappguncel.appspot.com/"'ın bulunduğu yere
            // yukarıda "fileName" ile belirtilen kısım dosya/dosya/image/rakam.jpg formatta dosya oluşturulacak.
           let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)

            
            //storageRef ile belirtilen dosya formatına uygun yerleştirme yap
            storageRef.putData(picture, metadata: nil, completion: { (metaData, error) in

                uploadCounter += 1

                if error != nil {

                    print("resim yükleme esnasında hata oluştu.\(error!.localizedDescription)")
                    return
                }

                storageRef.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        
                         print("generate url esnasında bir hata meydana geldi \(error.debugDescription)")
                    }
                    
                    let link = url?.absoluteString
                    linkString = linkString + link! + ","
                   
                    if uploadCounter == pictures.count {
                        withBlock(linkString)
                    }
                    
                })
                
            })
            
        }
        
        
        
    }
    
   
    
}



// MARK: Help Functions


// image verisi data ya çevrilir.
func convertImagesToData(images: [UIImage], withBlock: @escaping (_ datas: [Data])->Void) {
    
    var imageData: [Data] = []
    
    for image in images {
        
        // UIImageJPEGRepresentation: ilk parametre image dosyası. ikincisi kalite katsayısı
        // UIImageJPEGRepresentation: Returns the data for the specified image in JPEG format.
        let data = UIImageJPEGRepresentation(image, 0.5)!
        imageData.append(data)
        withBlock(imageData)
    }
    
}




// , ile sıralı imageLink url lerini alıp tek tek ayırıp url dizisi dönüyoruz.
func seperateImageLinks(allLinks: String) -> [String] {
    
    // mutable hatası: let yerine var yapıldığında geçiyor.
    // mutable: Değişken
    var linkedList = allLinks.components(separatedBy: ",")
    linkedList.removeLast()
    
    return linkedList
}


