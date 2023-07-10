//
//  LikeView.swift
//  Modo
//
//  Created by MacBook on 2023/05/13.
//

import SwiftUI

struct LikeView: View {
    @State var isShowingBookDetailSheet: Bool = false
    @State var selectedBook: Book? = nil
    
    @StateObject var bookVM: BookViewModel = BookViewModel()
    
    var body: some View {
            ScrollView {
                //책 리스트
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
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 20)
                                            .foregroundColor(Color("Brown1"))
                                    }
                                    //.padding(.trailing,10)
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
                                        selectedBook = book
                                        isShowingBookDetailSheet = true
                                    }) {
                                        Text("대여하기")
                                    }
                                    .buttonStyle(ActionBrownButton())
                                }
                            }
                                .padding(.trailing,20)
                        }
                    }
                }
                .frame(width: Screen.maxWidth)
            }//ScrollView
            .fullScreenCover(item: $selectedBook, content: { book in
                BookDetailView(selectedBook: book){
                    selectedBook = nil
                }
            })
            .navigationBarTitle("찜 목록")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct LikeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LikeView()
        }
    }
}
