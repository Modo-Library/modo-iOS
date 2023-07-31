//
//  S3ImageViewModel.swift
//  NewModo
//
//  Created by MacBook on 2023/07/28.
//

import Foundation
import Alamofire
import _PhotosUI_SwiftUI
import SDWebImageWebPCoder
import Combine

class S3ImageViewModel : ObservableObject {
    var tsetKeyName: String = ""
    @Published var uiImage: UIImage?
    @Published var photo: PhotosPickerItem?
    var webpData: Data?
    var pngData: Data?
    
    func updateKeyName() {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd/"
        tsetKeyName += dateFormat.string(from: Date())
        tsetKeyName += String(Int64(Date().timeIntervalSince1970)) + "_"
        tsetKeyName += UUID().uuidString + ".webp"
        
    }
    
    func encodeUIImageToPngData(uiImage: UIImage) async{
        guard let data = uiImage.pngData() else {
            NSLog("Encode failed: wrong data")
            return
        }
        
        self.pngData = data
    }
    
    
    func uploadImageToBackendAPIWithAlamofire(imageData: Data) {
        // 백엔드 API의 엔드포인트 URL
        let backendAPIURLString = "https://modo-deploy.s3.ap-northeast-2.amazonaws.com/20220105_testdy3.webp?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230728T094510Z&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Expires=600&X-Amz-Credential=AKIA5ZBXY47OTEPHDZ57%2F20230728%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=e7783871c70d42a4a3696191519f67fa5fd6b24422bf100cd8bc7829e0dfc0de"

        // HTTP Header 설정 (옵션)
        let headers: HTTPHeaders = [
            "Content-Type": "image/webp"
            //"Content-Type": "application/octet-stream", // binary 데이터로 전송할 경우
        ]

        // Alamofire를 사용하여 이미지 데이터를 백엔드 API에 PUT 요청으로 보내기
        AF.upload(imageData, to: backendAPIURLString, method: .put, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            // 성공적으로 요청이 처리되었을 때의 처리 로직
                            print("Image uploaded successfully!")
                        } else {
                            // 요청이 실패했을 때의 처리 로직
                            print("Request failed with status code: \(statusCode)")
                            if let error = response.error {
                                print("error: \(String(describing: error.localizedDescription))")
                            }
                        }
                    }
                case .failure(let error):
                    // 요청 실패시의 처리 로직
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    func encodeImageToWebp(uiImage: UIImage) async{
        dump(#function)
        
        guard let data = uiImage.pngData() else {
            NSLog("Encode failed: wrong data")
            return
        }
        
        guard let downSampledUIImage = await downSample(at: data, to: CGSize(width: 200, height: 200), scale: 2) else {
            NSLog("Encode failed: failed down sampled image")
            return
        }
        
        self.uiImage = downSampledUIImage
        
        guard let webpData = await encodeData(uiImage: downSampledUIImage) else {
            NSLog("Encode failed: failed uiimage to webpdata encode")
            return
        }
        self.webpData = webpData
        
        
        NSLog("Success: End encode")
        print("webpdata:\(String(describing: webpData))")
    }
    
    // Encode UIImage to webp image data
    func encodeData(uiImage: UIImage) async -> Data? {
        dump(#function)
        //limit output file size <= 10KB
        let options: [SDImageCoderOption: Any] = [.encodeCompressionQuality: 0.1,.encodeMaxFileSize: 1024 * 10]
        let data = SDImageWebPCoder.shared.encodedData(with: uiImage, format: .webP, options: options)
        return data
    }
    
    // Down sampling UIImage data type,and return down sampled UIImage
    func downSample(at data: Data, to pointSize: CGSize, scale: CGFloat) async -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions)  else {
            return nil
        }
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as [CFString : Any] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return UIImage()
        }
        return UIImage(cgImage: downsampledImage)
    }
    
}

