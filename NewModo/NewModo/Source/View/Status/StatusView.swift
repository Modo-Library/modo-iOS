//
//  StatusView.swift
//  Modo
//
//  Created by MacBook on 2023/05/13.
//

import SwiftUI

struct StatusView: View {
    @StateObject var bookVM: BookViewModel = BookViewModel()
    @State var selectedType = 0
    @State var bookState : String = "리뷰쓰기"//"대여하기"
    @State var isAlert: Bool = false
    var arrTypes : [String] = ["빌린 책","빌려준 책"]
    
    var body: some View {
        VStack{
            Picker("Convert", selection: $selectedType) {
                ForEach(0 ..< 2, id: \.self)
                { i in
                    Text(self.arrTypes[i])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            ScrollView{
                if selectedType == 0 {
                    VStack(alignment: .leading){
                        Divider()
                        HStack{
                            AsyncImage(url:URL(string: "https://shopping-phinf.pstatic.net/main_3250609/32506091444.20230425164419.jpg?type=w300")!) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                            }
                            .frame(width: Screen.maxHeight*0.12, height: Screen.maxHeight*0.12)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("어린 왕자")
                                        .font(.pretendardHeadlineBold)
                                    Spacer()
                                    Text("반납완료")
                                        .underline()
                                        .foregroundColor(Color("Brown3"))
                                        .font(.pretendardHeadline)
                                }
                                Text("생텍쥐페리")
                                    .font(.pretendardCallout)
                                    .foregroundColor(.secondary)
                                    .padding(.top,-5)
                                HStack{
                                    Text("500 원")
                                        .font(.pretendardHeadline)
                                    Spacer()
                                    actionNavLink(to: WriteReviewView(), title: "\(bookState)")
                                }
                            }
                            .padding(.trailing,20)
                        }
                    }
                        //                            ForEach(bookVM.books) { book in
                        //                                Divider()
                        //                                HStack{
                        //                                    AsyncImage(url:URL(string: "\(book.imageURL)")!) { image in
                        //                                        image
                        //                                            .resizable()
                        //                                            .scaledToFit()
                        //                                    } placeholder: {
                        //                                        RoundedRectangle(cornerRadius: 8)
                        //                                    }
                        //                                    .frame(width: Screen.maxHeight*0.12, height: Screen.maxHeight*0.12)
                        //
                        //                                    VStack(alignment: .leading){
                        //                                        HStack{
                        //                                            Text("\(book.name)")
                        //                                                .font(.pretendardHeadlineBold)
                        //                                            Spacer()
                        //                                            Text("반납완료")
                        //                                                .underline()
                        //                                                .foregroundColor(Color("Brown3"))
                        //                                                .font(.pretendardHeadline)
                        //                                        }
                        //                                        Text("\(book.author)")
                        //                                            .font(.pretendardCallout)
                        //                                            .foregroundColor(.secondary)
                        //                                            .padding(.top,-5)
                        //                                        HStack{
                        //                                            Text("\(book.price) 원")
                        //                                                .font(.pretendardHeadline)
                        //                                            Spacer()
                        //                                            actionNavLink(to: WriteReviewView(), title: "리뷰쓰기")
                        //                                        }
                        //                                    }
                        //                                    .padding(.trailing,20)
                        //
                        //                                }
                        //                            }
                }else{
                    VStack(alignment: .leading){
                        ForEach(bookVM.books) { book in
                            Divider()
                            HStack{
                                AsyncImage(url:URL(string: "\(book.imageURL)")!) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 8)
                                }
                                .frame(width: Screen.maxHeight*0.12, height: Screen.maxHeight*0.12)
                                
                                VStack(alignment: .leading){
                                    HStack{
                                        Text("\(book.name)")
                                            .font(.pretendardHeadlineBold)
                                        Spacer()
                                        Text("대여중")
                                            .underline()
                                            .foregroundColor(Color("Brown3"))
                                            .font(.pretendardHeadline)
                                    }
                                    Text("\(book.author)")
                                        .font(.pretendardCallout)
                                        .foregroundColor(.secondary)
                                        .padding(.top,-5)
                                    HStack{
                                        Text("\(book.price) 원")
                                            .font(.pretendardHeadline)
                                        Spacer()
                                        
                                        Button(action: {
                                            isAlert = true
                                        }) {
                                            Text("반납 완료")
                                        }
                                        .buttonStyle(ActionBrownButton())
                                    }
                                }
                                .padding(.trailing,20)
                                
                            }
                        }
                    }
                    .frame(width: Screen.maxWidth)
                }
            }
        }//VStack
        .alert("반납완료", isPresented: $isAlert, actions: {
            Button(action: {
                isAlert = false
            }) {
                Text("확인")
            }
            Button(action: {
                isAlert = false
            }) {
                Text("취소")
            }
        }, message: {
            Text("상대방이 본인에게 책을 전달해주셨습니까?")
        })
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            StatusView()
        }
    }
}
