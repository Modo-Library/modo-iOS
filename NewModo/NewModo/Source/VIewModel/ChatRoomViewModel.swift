//
//  ChatRoomViewModel.swift
//  Modo
//
//  Created by MacBook on 2023/05/25.
//

import Foundation

class ChatRoomViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = ChatRoom.getDummy()
    @Published var selectedChatRoom: ChatRoom? = nil
    
}
