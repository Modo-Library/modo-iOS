//
//  MessageViewModel.swift
//  Modo
//
//  Created by MacBook on 2023/05/18.
//

import SwiftUI

class MessageViewModel : ObservableObject {
    @Published var messages: [Message] = []
    @Published var sendText: String = ""
    
    var isEmptySendText: Bool {
        return sendText == ""
    }
    
    func sendMessage(){
        if sendText != "" {
            messages.append(Message(id: UUID().uuidString, sender: "currentUser", text: sendText, date: Date()))
            sendText = ""
            }
    }
    
    func timerMessage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.messages.append(Message(id: UUID().uuidString, sender: "otherUser", text: "안녕하세요", date: Date()))
        })
    }
                                      
}

