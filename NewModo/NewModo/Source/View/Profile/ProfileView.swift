//
//  ProfileView.swift
//  Modo
//
//  Created by MacBook on 2023/05/13.
//

import SwiftUI

struct ProfileView: View {
    @State var isNotificationAgreed : Bool = false
    @State var sharePower: Float = 200
    
    var body: some View {
        VStack{
            List{
                ProfileHeaderView()
                Section{
                    VStack(alignment: .leading){
                        HStack{
                            Text("공유 파워")
                                .font(.pretendardFootnoteBold)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(Int(sharePower)) 점")
                                .font(.pretendardHeadline)
                        }
                        ZStack{
                            Rectangle()
                                .frame(width:Screen.maxWidth*0.8 ,height: 1)
                                .foregroundColor(.gray)
                            HStack{
                                Rectangle()
                                    .frame(width:Screen.maxWidth*0.8*(CGFloat(sharePower)/2000.0),height: 3)
                                    .foregroundColor(Color("Brown3"))
                                Spacer()
                            }
                        }
                    }
                }
                
                
                Section {
                    NavigationLink(destination: EmptyView()) {
                        Text("리뷰관리")
                            .font(.pretendardHeadline)
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("리더보드")
                            .font(.pretendardHeadline)
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("공지사항")
                            .font(.pretendardHeadline)
                    }
                } header: {
                    Text("기능")
                        .font(.pretendardFootnoteBold)
                }
                .listRowBackground(Color("Gray1"))
                
                Section {
                    HStack{
                        Text("알림 설정")
                            .font(.pretendardHeadline)
                        Spacer()
                        Toggle(isOn: $isNotificationAgreed) {
                            Text("")
                        }
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("이용약관")
                            .font(.pretendardHeadline)
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("개인정보 처리방침")
                            .font(.pretendardHeadline)
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("로그아웃")
                            .font(.pretendardHeadline)
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("회원탈퇴")
                            .font(.pretendardHeadline)
                    }
                } header: {
                    Text("어플리케이션 설정")
                        .font(.pretendardFootnoteBold)
                }//section
                .listRowBackground(Color("Gray1"))
                
            }//list
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .background(.white)
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
        .frame(width: Screen.maxWidth*0.83)
        .padding(.horizontal,10)
        .padding(.vertical,10)
        .overlay{
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Gray1"), lineWidth: 2)
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView()
        }
    }
}
