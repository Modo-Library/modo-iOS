//
//  SignInView.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//

import SwiftUI

private enum FocusableField: Hashable {
    case id
    case pw
    case login
}

struct SignInView: View {
    
    @Binding var authState : AuthState
    
    @FocusState private var focus : FocusableField?
    
    @State private var isLoggedIn : Bool = false
    @State private var id : String = ""
    @State private var pw : String = ""
    @State private var isShowingPw : Bool = false
    @State private var isSignInButtonDisabled : Bool = true
    
    // 연산프로퍼티
    private var isDisabledLoginBtn: Bool {
        if pw.count > 8 && pw.count < 20 && id != "" {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack{
            
            //로고 이미지
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height:70)
                HStack{
                    Text("모두의")
                        .foregroundColor(Color("Brown0"))
                        .font(.pretendardLargeTitle)
                        .bold()
                    Text("도서관")
                        .foregroundColor(.black)
                        .font(.pretendardLargeTitle)
                        .bold()
                }
            }
            .padding([.top,.bottom],Screen.maxHeight*0.05)
            
            //아이디 입력
            Group{
                HStack{
                    Text("아이디")
                        .font(.pretendardHeadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 0.2)
                    .frame(height: Screen.maxHeight*0.05)
                    .overlay {
                        TextField("아이디 입력", text: $id)
                            .focused($focus, equals: .id)
                            .font(.pretendardCallout)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                self.focus = .pw
                            }
                    }
            }
            
            //비밀번호 입력
            Group{
                HStack{
                    Text("비밀번호")
                        .font(.pretendardHeadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.top,20)
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 0.2)
                    .frame(height: Screen.maxHeight*0.05)
                    .overlay {
                        if isShowingPw {
                            TextField("비밀번호 입력", text: $pw)
                                .focused($focus, equals: .pw)
                                .font(.pretendardCallout)
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .onSubmit {
                                    // 로그인 함수
                                    print("로그인 버튼 클릭")
                                }
                                .overlay {
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            isShowingPw.toggle()
                                        }) {
                                            Image(systemName: "eye.slash")
                                        }
                                        .foregroundColor(.secondary)
                                        .padding(.trailing,10)
                                    }
                                    
                                }
                        }
                        else{
                            SecureField("비밀번호 입력", text: $pw)
                                .focused($focus, equals: .pw)
                                .font(.pretendardCallout)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                            
                                .onSubmit {
                                    // 로그인 함수
                                    print("로그인 버튼 클릭")
                                }
                                .overlay {
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            isShowingPw.toggle()
                                        }) {
                                            Image(systemName: "eye")
                                        }
                                        .foregroundColor(.secondary)
                                        .padding(.trailing,10)
                                    }
                                    
                                }
                        }
                        
                    }
            }
            Button(action: {
                //로그인 시도 메소드
                withAnimation(.easeInOut){
                    authState = .authenticated
                }
            }) {
                Text("로그인")
            }
                .buttonStyle(BasicBrownButton())
                .padding(.top,20)
            
            Spacer()
            
            //회원가입 버튼
            Group{
                HStack{
                    Text("계정이 없으신가요?")
                    Spacer()
                }
                
                NavigationLink(destination: SignUpView()) {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("Brown0"), lineWidth: 1)
                        .frame(height: 55)
                    
                        .overlay {
                            Text("회원가입 하기")
                                .font(.pretendardTitle3)
                                .foregroundColor(Color("Brown0"))
                        }
                }
                .padding(.bottom,30)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // <-
            .onTapGesture { // <-
                endTextEditing()
            }
        
        
    }
}

struct SignInView_Previews: PreviewProvider {
    @State static var authState : AuthState = .signIn
    static var previews: some View {
        NavigationView{
            SignInView(authState: $authState)
        }
    }
}
