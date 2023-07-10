//
//  ChatView.swift
//  Modo
//
//  Created by MacBook on 2023/05/13.
//

import SwiftUI

struct ChatRoom : Identifiable{
    let id = UUID().uuidString
    var name : String
    var book: Book
    var latestMessage: String
    let createdAt: Date
    
    // 시간 차이로 나타내기
    var descriptionDate: String {
        let diff = Date().timeIntervalSince(createdAt)
        
        switch diff {
        case 0..<60:
            return "방금 전"
        case 60..<3600:
            return "\(Int(diff/60))분 전"
        case 3600..<86400: // 24시간 이전
            return "\(Int(diff/3600))시간 전"
        case 86400..<604800: // 이번주 내
            return "\(Int(diff/86400))일 전"
        case 604800..<2592000:
            return createdAt.getDay(format: "dd일")
        default:
            return createdAt.getDay(format: "MM월")
        }
    }
    
    static func getDummy()->[ChatRoom] {
        return [ChatRoom(name: "박시연", book: Book.getDummy()[0], latestMessage: "안녕하세요", createdAt: Date(timeInterval: -1200, since: Date())),
                ChatRoom(name: "김승민", book: Book.getDummy()[1], latestMessage: "네 알겠습니다", createdAt: Date(timeInterval: -6000, since: Date())),
                ChatRoom(name: "구범준", book: Book.getDummy()[2], latestMessage: "내일 8시에 빌려드릴게요", createdAt: Date(timeInterval: -12000, since: Date()))
        ]
    }
}

struct ChatView: View {
    
    @StateObject var chatRoomVM: ChatRoomViewModel = ChatRoomViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView{
                ForEach(chatRoomVM.chatRooms) { chatRoom in
                    NavigationLink(destination: ChatDetailView(book:Book.getDummy()[0])) {
                        HStack{
                            Circle()
                                .fill(.secondary)
                                .padding(.trailing,10)
                                .padding(.horizontal,10)
                                .frame(height: Screen.maxHeight*0.055)
                            VStack(alignment: .leading){
                                HStack{
                                    Text("\(chatRoom.name)의 도서관")
                                        .font(.pretendardCalloutBold)
                                    Spacer()
                                    Text("\(chatRoom.descriptionDate)")
                                        .font(.pretendardCaption)
                                        .foregroundColor(.secondary)
                                        .padding(.trailing,15)
                                }
                                Text("\(chatRoom.book.name)")
                                    .font(.pretendardCaption)
                                    .foregroundColor(Color("Brown2"))
                                    .padding(.top,-5)
                                Text("\(chatRoom.latestMessage)")
                                    .font(.pretendardCallout)
                                    .foregroundColor(.secondary)
                                    .padding(.top,-5)
                                
                            }
                            Spacer()
                            Rectangle()
                                .fill(Color("Gray1"))
                                .frame(width: Screen.maxWidth*0.06, height: Screen.maxHeight*0.06)
                                .overlay {
                                    AsyncImage(url:URL(string: chatRoom.book.imageURL)!) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 8)
                                    }
                                    .frame(width: Screen.maxHeight*0.06, height: Screen.maxHeight*0.06)
                                }
                        }
                        .frame(height:Screen.maxHeight*0.08)
                    }
                    .tint(Color("Brown3"))
                    Divider()
                }
                .padding()
            }
            
        }//VStack
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChatView()
        }
    }
}
