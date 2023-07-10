//
//  ChatDetailView.swift
//  Modo
//
//  Created by MacBook on 2023/05/17.
//

import SwiftUI
import Combine

struct ChatDetailView: View {
    @ObservedObject var messageVM: MessageViewModel = MessageViewModel()
    @Environment(\.dismiss) var dismiss
    @State var isShowingAlert: Bool = false
    @Namespace var topID
    @Namespace var bottomID
    
    var book: Book? = nil
    
    var body: some View {
        ZStack{
            // 대여 확인 메시지
            if isShowingAlert {
                Color(.black)
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        isShowingAlert = false
                    }
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .frame(width: Screen.maxWidth*0.7, height: Screen.maxHeight*0.32)
                    .overlay {
                        VStack{
                            Text("책을 대여해주시겠습니까?")
                                .font(.pretendardHeadlineBold)
                            
                            Image("saly")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Screen.maxWidth*0.4)
                            Spacer()
                            Divider()
                            HStack{
                                Button(action: {
                                    isShowingAlert = false
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: Screen.maxWidth*0.33,height: Screen.maxHeight*0.048)
                                        .overlay {
                                            Text("예")
                                                .font(.pretendardHeadlineBold)
                                                .foregroundColor(.black)
                                        }
                                }
                                Divider()
                                
                                Button(action: {
                                    isShowingAlert = false
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: Screen.maxWidth*0.33,height: Screen.maxHeight*0.048)
                                        .overlay {
                                            Text("아니요")
                                                .font(.pretendardHeadlineBold)
                                                .foregroundColor(.black)
                                        }
                                }
                            }
                            .frame(height: Screen.maxHeight*0.05)
                        }
                        .padding()
                    }
                    .zIndex(2)
            }
            VStack{
                Divider()
                HStack{
                    AsyncImage(url:URL(string: "\(book!.imageURL)")!) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Rectangle()
                    }.frame(width: 70,height: 70)
                    
                    VStack(alignment: .leading){
                        Text("\(book!.name)")
                            .font(.pretendardHeadlineBold)//책이름
                        Text("\(book!.price)원")//가격
                            .font(.pretendardHeadline)
                    }
                    Spacer()
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Text("대여하기")
                    }
                    .buttonStyle(ActionBrownButton())
                }
                Divider()
                
                //채팅 대화 기록 뷰
                ScrollViewReader { proxy in
                    ScrollView{
                        ForEach(0..<messageVM.messages.count,id:\.self){ i in
                            VStack{
                                //날짜 헤더
                                if i==0 || messageVM.messages[i-1].yyyymmdd != messageVM.messages[i].yyyymmdd {
                                    Text(messageVM.messages[i].yyyymmdd)
                                        .font(.pretendardCaption)
                                }
                                MessageView(message: messageVM.messages[i])
                            }
                        }
                        Spacer()
                        HStack {}.id(bottomID)
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: messageVM.messages) { _ in
                        // 메시지 배열이 변경되면 스크롤 위치를 최하단으로 이동
                        withAnimation {  proxy.scrollTo(bottomID) }
                        
                    }
                    .onAppear {
                        // 초기에 스크롤 위치를 최하단으로 이동
                        withAnimation { proxy.scrollTo(bottomID) }
                    }
                }//ScrollviewReader
                SendMessageView()
                
            }
            .padding()
            .navigationTitle("\("박시연")") // 이름
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Brown3"))
                            .font(.pretendardTitle3Bold)
                    }
                }
            })
            .onAppear{
                UITextView.appearance().backgroundColor = .clear
            }
            .zIndex(0)
        }
        .onTapGesture {
            endTextEditing()
        }
        .onAppear{
            UITextView.appearance().backgroundColor = .clear
            messageVM.timerMessage()
        }
    }
    
    @ViewBuilder
    private func MessageView(message: Message) -> some View {
        if message.sender == "currentUser"{
            HStack(alignment: .bottom){
                Spacer()
                Text(message.timeString)
                    .font(.pretendardFootnote)
                
                Text(message.text)
                    .font(.pretendardHeadline)
                    .lineLimit(nil) // 무제한 줄
                    .fixedSize(horizontal: false, vertical: true) // 텍스트가 넘칠 경우 다음 줄로 넘어감
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("Brown0"))
                    }
            }
        }else{
            HStack(alignment: .bottom){
                Text(message.text)
                    .font(.pretendardHeadline)
                    .lineLimit(nil) // 무제한 줄
                    .fixedSize(horizontal: false, vertical: true) // 텍스트가 넘칠 경우 다음 줄로 넘어감
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.secondary)
                    }
                Text(message.timeString)
                    .font(.pretendardFootnote)
                Spacer()
            }
        }
    }
    
    
    @ViewBuilder
    private func SendMessageView() -> some View {
        //메세지 보내기 텍스트 필드
        HStack{
            TextEditor(text: $messageVM.sendText)
                .colorMultiply(Color.gray.opacity(0.2))
                .font(.pretendardHeadline)
                .frame(height: Screen.maxHeight*0.05)
                .cornerRadius(20.5)
                .overlay {
                    if messageVM.isEmptySendText {
                        HStack{
                            Text("메세지 보내기")
                                .font(.pretendardHeadline)
                                .foregroundColor(.gray)
                                .padding(.leading,20)
                            Spacer()
                        }
                    }
                }
            Spacer()
            Button(action: {
                messageVM.sendMessage()
            }) {
                Image(systemName: "paperplane")
                    .font(.pretendardTitle3)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}


struct ChatDetailView_Previews: PreviewProvider {
    
    static var book: Book = Book.getDummy()[0]
    static var previews: some View {
        NavigationView{
            ChatDetailView(book: book)
            
        }
    }
}
