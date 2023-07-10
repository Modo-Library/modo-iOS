//
//  BookDetailView.swift
//  Modo
//
//  Created by MacBook on 2023/05/15.
//

import SwiftUI

struct BookDetailView: View {
    
    var selectedBook: Book?
    let closeAction : ()->Void
    @State var isHeartTapped: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Rectangle()
                    .fill(Color("Gray1"))
                    .frame(height: Screen.maxHeight*0.45)
                    .overlay {
                        AsyncImage(url:URL(string: "\(selectedBook!.imageURL)")!) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                        }
                        .frame(width: Screen.maxHeight*0.3, height: Screen.maxHeight*0.3)
                        .padding(.top,30)
                    }
                
                VStack(alignment: .leading){
                    ProfileHeaderView()
                    Divider()
                    HStack{
                        Text("\(selectedBook!.name)")
                            .font(.pretendardTitle2Bold)
                        
                        Text("  \(selectedBook!.author)")
                            .font(.pretendardCallout)
                            .foregroundColor(.secondary)
                        
                        //task: 로그인한 유저의 도서 일 경우 수정/삭제 버튼 추가
                    }
                    Text("\(selectedBook!.description)")
                        .padding(.top,25)
                        .font(.pretendardHeadline)
                    Spacer()
                    VStack(alignment: .leading){
                        HStack{
                            Button(action: {
                                isHeartTapped.toggle()
                            }) {
                                Image(systemName: isHeartTapped ? "heart.fill" : "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .foregroundColor(isHeartTapped ? Color("Brown1") : .secondary)
                            }
                            Divider()
                            Text("\(selectedBook!.price) 원")
                                .font(.pretendardHeadlineBold)
                            Spacer()
                            actionNavLink(to: ChatDetailView(book: selectedBook), title: "채팅하기")
                        }
                    }
                    .frame(height: Screen.maxHeight*0.06)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color("Gray1"))
                            .frame(width: Screen.maxWidth)
                            .ignoresSafeArea(.all,edges: .bottom)
                    }
                    
                }
                .padding()
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        closeAction()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Brown3"))
                            .font(.pretendardTitle3Bold)
                    }
                }
            })
        }
    }
    
    @ViewBuilder
    func ProfileHeaderView()-> some View {
            HStack{
                Circle()
                    .fill(Color("Gray1"))
                    .frame(height:Screen.maxHeight*0.07)
                    .overlay(content: {
                        Image("profileImg")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:Screen.maxHeight*0.045)
                    })
                    .padding(.trailing,10)
                VStack(alignment: .leading,spacing: 3){
                    Text("움직이는 도서관")
                        .font(.pretendardFootnote)
                        .foregroundColor(.white)
                        .padding(1)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color("Brown3"))
                        )
                    Text("허두영의 도서관")
                        .font(.pretendardTitle3)
                }
                Spacer()
                Image("silverMedal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                
            }
            .padding(.horizontal,20)
            .padding(.vertical,10)
    }
    
}

struct BookDetailView_Previews: PreviewProvider {
    @State static var book: Book? = Book.getDummy()[0]
    
    static var previews: some View {
        NavigationView{
            BookDetailView(selectedBook: book){
                print("close")
            }
        }
    }
}
