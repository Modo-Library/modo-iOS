//
//  HomeView.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var coordinator : HomeCoordinator = HomeCoordinator.shared
    //@State var cameraPosition: LatLng = (0,0)//(126.984996, 37.561059)// 현 기기값
    @State var currentIndex: Int = 0
    @State var isShowingAddSheet: Bool = false
    @State var isShowingLibrarySheet: Int = 1
    @State var isShowingBookDetailSheet: Bool = false
    @State var selectedBook: Book? = nil
    
    @StateObject var bookVM: BookViewModel = BookViewModel()
    var users: [User] = User.getDummy()
    
    var body: some View {
        ZStack{
            HomeNaverMap()
            //HomeNaverMap(cameraPosition: $cameraPosition)
            VStack{
                Spacer()
                HStack{
                    //현재위치 버튼
                    Button(action: {
                        coordinator.checkIfLocationServicesIsEnabled()
                        //cameraPosition = coordinator.userLocation
                    }) {
                        Circle()
                            .fill(.white)
                            .frame(height: 40)
                            .shadow(radius: 5)
                            .overlay{
                            Image(systemName: "location")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height:18)
                                    .foregroundColor(.black)
                        }
                            .padding()
                    }
                    Spacer()
                    //도서 추가 버튼
                    Button(action: {
                        isShowingAddSheet.toggle()
                    }) {
                        Circle()
                            .fill(Color("Brown1"))
                            .frame(height: 50)
                            .shadow(radius: 5)
                            .overlay{
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height:20)
                                    .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
            }
            .zIndex(1)
            if coordinator.isMarkerTapped {
            
            // MARK: - 도서관 디테일 뷰 (도서관 정보, 도서관에 빌릴 수 있는 책)
                VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.white)
                        .frame(height: isShowingLibrarySheet == 1 ? Screen.maxHeight*0.15 : Screen.maxHeight*0.3)
                        .overlay {
                            VStack{
                                Button(action: {
                                    if isShowingLibrarySheet == 1 {
                                        isShowingLibrarySheet = 2
                                    }else{
                                        isShowingLibrarySheet = 1
                                    }
                                }) {
                                    Image(systemName: isShowingLibrarySheet == 1 ? "chevron.up" : "chevron.down")
                                        .font(.pretendardHeadlineBold)
                                        .foregroundColor(Color("Brown3"))
                                }
                                .padding(.top,5)
                                ScrollView {
                                    //책 리스트
                                    VStack(alignment: .leading){
                                        ProfileHeaderView()
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
                                                    Text("\(book.name)")
                                                        .font(.pretendardTitle3Bold)
                                                    Text("\(book.author)")
                                                        .font(.pretendardCallout)
                                                        .foregroundColor(.secondary)
                                                        .padding(.top,-5)
                                                    HStack{
                                                        Text("\(book.price) 원")
                                                            .font(.pretendardHeadlineBold)
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
                                                .padding()
                                            }
                                        }
                                    }
                                    .padding()
                                    .frame(width: Screen.maxWidth)
                                }
                            }
                            .background {
                                Color("Gray1")
                            }
                        }
                }
                .zIndex(2)
            }
        }
            .ignoresSafeArea(.all, edges: .top)
            .fullScreenCover(isPresented: $isShowingAddSheet) {
                AddBookView(isShowingSheet: $isShowingAddSheet)
            }
            .fullScreenCover(item: $selectedBook, content: { book in
                BookDetailView(selectedBook: book){
                    selectedBook = nil
                }
            })
        
        .onAppear{
            //coordinator.checkIfLocationServicesIsEnabled()
            //cameraPosition = coordinator.userLocation
            //coordinator.makeMarkers()
            isShowingLibrarySheet = 1
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
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Gray1"), lineWidth: 2)
                }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
