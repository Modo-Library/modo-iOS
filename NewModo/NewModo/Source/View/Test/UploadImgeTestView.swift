//
//  UploadImgeTestView.swift
//  NewModo
//
//  Created by MacBook on 2023/07/28.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct UploadImgeTestView: View {
    @State private var image: Image?
    @State private var webpImage: WebImage?
    
    @ObservedObject var s3ImageVM = S3ImageViewModel()
    
    var body: some View {
        
        
        VStack {
            // webp image url 불러오기 테스트
            if let webpImage {
                webpImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
            }else{
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200, alignment: .center)
            }
            
            // 선택한 사진
            if let image = s3ImageVM.uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
            }else{
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200, alignment: .center)
            }
            
            // PhotosUI 사진 선택기
            PhotosPicker(selection: $s3ImageVM.photo) {
                HStack{
                    Image(systemName: "photo")
                    Text("Select your photo")
                }
                .foregroundColor(.white)
                .padding(10)
                .buttonStyle(.borderedProminent)
                .background(.black)
            }
            .onChange(of: s3ImageVM.photo, perform: { photo in
                Task {
                    if let photo, let data = try? await photo.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            await s3ImageVM.encodeImageToWebp(uiImage: uiImage)
                            
                            await s3ImageVM.encodeUIImageToPngData(uiImage: uiImage)
                        }
                    }
                }
            })//onChange
            
            // Test Upload button
            Button(action: {
                if let data = s3ImageVM.pngData {
                    s3ImageVM.uploadImageToBackendAPIWithAlamofire(imageData: data)
                }
                
                
            }) {
                Text("Upload")
                    .font(.pretendardTitle3Bold)
            }
            .buttonStyle(.bordered)
            .tint(.blue)
        }
        .padding()
        .onAppear{
            
            webpImage = WebImage(url: URL(string: "https://www.gstatic.com/webp/gallery/4.sm.webp"))
        }
        
    }
    
}

struct UploadImgeTestView_Previews: PreviewProvider {
    static var previews: some View {
        UploadImgeTestView()
    }
}
