//
//  AddBookView.swift
//  Modo
//
//  Created by MacBook on 2023/05/14.
//

import SwiftUI

struct AddBookView: View {
    @Binding var isShowingSheet: Bool
    @State var searchText: String = ""
    @StateObject var naverBookSearchVM = NaverBookViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    TextField("등록할 책이름을 검색해주세요", text: $searchText)
                        .padding(7)
                        .padding(.horizontal,25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay {
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0,maxWidth: .infinity,alignment: .leading)
                                    .padding(.leading,8)
                                
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing,8)
                                }
                            }
                        }
                    Button(action: {
                        naverBookSearchVM.fetchNaverBookSearch(bookName: searchText)
                    }) {
                        Text("검색")
                    }
                    .padding(.horizontal,10)
                    .transition(.move(edge: .trailing))
                    .animation(.default, value: searchText)
                    
                }//HStack
                    .padding()
                ScrollView{
                    VStack(alignment: .leading){
                        ForEach(naverBookSearchVM.searchResultBooks,id: \.self) { book in
                            Divider()
                            NavigationLink(destination: AddBookDetailView(bookInfo: book,isShowingSheet: $isShowingSheet)) {
                                
                                HStack{
                                    AsyncImage(url:URL(string: "\(book.image)")!) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 8)
                                    }
                                    .frame(width: Screen.maxHeight*0.12, height: Screen.maxHeight*0.12)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(book.title)")
                                            .font(.pretendardHeadlineBold)
                                        Text("\(book.author)")
                                            .font(.pretendardCallout)
                                            .foregroundColor(.secondary)
                                            .padding(.top,-5)
                                        Text("\(book.publisher)")
                                            .font(.pretendardCallout)
                                            .foregroundColor(.secondary)
                                            .padding(.top,-5)
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                Spacer()
                
            }
            .navigationBarTitle("책 등록", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingSheet.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:20)
                            .foregroundColor(Color("Brown1"))
                    }
                }
            }
        }
        
    }
}

struct AddBookView_Previews: PreviewProvider {
    @State static var isShowingSheet: Bool = true
    
    static var previews: some View {
        NavigationView {
            AddBookView(isShowingSheet: $isShowingSheet)
            
        }
    }
}
