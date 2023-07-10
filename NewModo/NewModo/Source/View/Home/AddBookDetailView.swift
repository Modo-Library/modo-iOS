//
//  AddBookDetailView.swift
//  Modo
//
//  Created by MacBook on 2023/05/23.
//

import SwiftUI
import Combine

enum BookKeyboardFocus : Hashable {
    case price
    case description
    
}

struct AddBookDetailView: View {
    let bookInfo: BookInfo
    @FocusState var focus : BookKeyboardFocus?
    @Environment(\.dismiss) var dismiss
    @State var description: String = ""
    @State var price: String = ""
    @Binding var isShowingSheet: Bool
    
    @Namespace var bottomID
    
    var body: some View {
        ScrollViewReader{ proxy in
        ScrollView{
            VStack(alignment: .leading,spacing: 18){
                HStack(alignment: .center){
                    VStack(alignment: .leading){
                        VStack(alignment: .leading,spacing: 5){
                            Text("제목")
                                .foregroundColor(.gray)
                                .font(.pretendardFootnoteBold)
                                .frame(alignment: .leading)
                            Text("\(bookInfo.title)")
                                .font(.pretendardHeadlineBold)
                        }
                        .padding(.bottom,20)
                        VStack(alignment: .leading,spacing: 5){
                            Text("저자")
                                .foregroundColor(.gray)
                                .font(.pretendardFootnoteBold)
                                .frame(alignment: .leading)
                            Text("\(bookInfo.author)")
                                .font(.pretendardHeadlineBold)
                        }
                    }
                    Spacer()
                    AsyncImage(url:URL(string: "\(bookInfo.image)")!) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                    }
                    .frame(width: Screen.maxHeight*0.12, height: Screen.maxHeight*0.12)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Gray1"))
                    }
                }
                
            Text("대여비")
                .foregroundColor(.gray)
                .font(.pretendardFootnoteBold)
                .frame(alignment: .leading)
            HStack{
                TextField("등록할 대여비의 금액을 작성해주세요", text: $price)
                    .font(.pretendardHeadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .modifier(JustEditNumberModifier(number : $price))
                    .padding(7)
                    .padding(.horizontal,10)
                    .background(Color("Gray1"))
                    .cornerRadius(8)
                    .focused($focus,equals: .price)
                    .onSubmit {
                        focus = .description
                        withAnimation{proxy.scrollTo(bottomID)}
                    }
                Text(" 원")
                    .font(.pretendardHeadline)
                    .foregroundColor(.gray)
                Spacer()
            }
                    
                Text("내용")
                    .foregroundColor(.gray)
                    .font(.pretendardFootnoteBold)
                    .frame(alignment: .leading)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("Gray1"))
                    .frame(width: Screen.maxWidth*0.8, height: Screen.maxWidth*0.4)
                    .overlay {
                        ZStack{
                            if description == "" {
                                VStack{
                                    Text("책에 대한 설명을 작성해주세요")
                                        .foregroundColor(.gray)
                                        .font(.pretendardSubhead)
                                        .frame(width: Screen.maxWidth*0.76,alignment: .leading)
                                    Spacer()
                                }
                                .padding(10)
                                .zIndex(1)
                            }
                            TextEditor(text: $description)
                                .colorMultiply(Color("Gray1"))
                                .foregroundColor(.black)
                                .font(.pretendardSubhead)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                                .focused($focus,equals: .description)
                                .frame(width: Screen.maxWidth*0.76)
                        }.frame(width: Screen.maxWidth*0.76, height: Screen.maxWidth*0.38)
                    }
                
                Button(action: {
                    isShowingSheet = false
                }) {
                    Text("등록하기")
                }
                .buttonStyle(BasicBrownButton())
                    
            }
            .padding()
            
            Spacer()
            
            HStack{}.id(bottomID)
        }
        .padding(30)
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Brown1"))
                        .font(.pretendardHeadlineBold)
                }
            }
        })
        .onTapGesture {
            endTextEditing()
        }
        .onAppear{
            UITextView.appearance().backgroundColor = .clear
            focus = .price
        }
        }
    }
}

// MARK: - Modifier 텍스트필드에서 숫자만 입력받는 모디파이어
struct JustEditNumberModifier : ViewModifier {
    @Binding var number : String
    
    func body(content: Content) -> some View {
        content
        // onReceive(_:perform:) : iOS13 이상, publisher 가 방출한 이벤트를 받아 view 에서 어떠한 action 을 하게 된다.
        // Just는 실패할 수 없고, 항상 값을 생산하는 Publisher 생성자
            .onReceive(Just(number)) { _ in
                
                // Number가 아닌 문자는 걸러내고, 걸러낸 문자열과 입력받은 문자열이 다르면 걸러낸 문자열로 대치
                let filteredString = number.filter { $0.isNumber }
                if filteredString != number {
                    number = filteredString
                }
            }
        
    }
}

struct AddBookDetailView_Previews: PreviewProvider {
    static let bookInfo: BookInfo = BookInfo(title: "세이노의 가르침", link: "", image: "https://shopping-phinf.pstatic.net/main_3731353/37313533623.20230512071205.jpg?type=w300", author: "세이노", discount: "18000", publisher: "출판사없음", pubdate: "", isbn: "", description: "")
    @State static var isShowingSheet: Bool = true
    static var previews: some View {
        AddBookDetailView(bookInfo: bookInfo,isShowingSheet: $isShowingSheet)
    }
}
