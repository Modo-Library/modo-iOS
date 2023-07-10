//
//  WriteReviewView.swift
//  Modo
//
//  Created by MacBook on 2023/05/21.
//

import SwiftUI

struct WriteReviewView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var starArr = Array(repeating: false, count: 5)
    @State var grade : Double = 0 // 별점
    @State var text = ""
    @State var isAlert: Bool = false
   
    
    var body: some View {
        ScrollView {
            VStack {
                //별점
                HStack(spacing: 15){
                    ForEach(0..<5,id: \.self){ index in
                        Image(systemName: "star.fill")
                            .resizable()
                            .foregroundColor(Double(index) < grade ? Color("Brown1") : Color.secondary)
                            .frame(width: 44, height: 44)
                            .onTapGesture {
                                grade = Double(index+1)
                            }
                    }
                } //HStack
                .padding(.vertical, 40)
                
                VStack {
                    //후기 Text
                    Text("상세한 후기를 써주세요.")
                        .font(.pretendardTitle3Bold)
                    ZStack {
                        if text.isEmpty {
                            TextEditor(text: .constant("작성 내용은 상대방 도서관에 노출되며 다른 사용자들이 볼 수 있으니, 서로를 배려하는 마음을 담아 작성 부탁드립니다."))
                                .lineSpacing(8)
                                .foregroundColor(.gray)
                                .disabled(true)
                                .scrollContentBackground(.hidden) // HERE
                                .background(Color("Gray1"))
                        }
                        TextEditor(text: $text)
                        //                            .focused($isInFocusText)
                            .opacity(text.isEmpty ? 0.25 : 1)
                    } //ZStack
                    .keyboardType(.default)
                    .padding([.leading, .trailing])
                    .scrollContentBackground(.hidden) // HERE
                    .background(Color("Gray1"))
                    .frame(height: 300)
                    .padding(.vertical, 10)
                    
                }//VStack
                .padding(.horizontal, 20)
            }
            //리뷰 등록
            Button {
                isAlert = true
                dismiss()
            } label: {
                    Text("리뷰 등록하기")
                        .font(.pretendardHeadline)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 120)
                        .background(text.count > 0 && text != "" ? Color("Brown1") : Color(.lightGray))
                        .cornerRadius(10)
                        .foregroundColor(.white)
            }
            .disabled(text.count > 0 ? false : true)
            
        }//ScrollView
        .onTapGesture { // 키보드가 올라왔을 때 다른 화면 터치 시 키보드가 내려감
            self.endTextEditing()
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitle("리뷰 쓰기", displayMode: .inline)
        .toolbar { //뒤로가기
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.pretendardHeadline)
                        .foregroundColor(Color("Brown1"))
                }
            }
        }
    }
}

struct WriteReviewView_Previews: PreviewProvider {
    static var previews: some View {
        WriteReviewView()
    }
}
