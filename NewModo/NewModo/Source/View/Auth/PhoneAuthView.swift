//
//  PhoneAuthView.swift
//  Modo
//
//  Created by MacBook on 2023/04/27.
//

import SwiftUI

enum SignUpState {
    case phone
    case map
    case detail
    case complete
}

//Task - 휴대폰번호 인증번호 받기 (인증) 버튼

struct PhoneAuthView: View {
    @ObservedObject var signUpVM = SignUpViewModel()
    
    @Binding var signUpState : SignUpState
    
    @State private var authNumber : String = ""
    @State var isAlert: Bool = false
    private var isCorrectPhone: Bool {
        if signUpVM.phoneNumber.count > 10 {
            return true
        }
        return false
    }
    
    private var isCorrectAuth: Bool {
        if authNumber.count > 0 {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Group{
                Text("본인인증")
                    .font(.pretendardTitle)
                    .padding(.top,10)
                
                Text("휴대폰 번호")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
                    .padding(.top,10)
                
                TextField("'-'을 제외하고 휴대폰 번호를 입력해주세요", text: $signUpVM.phoneNumber)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .font(.pretendardCallout)
                    .padding(.top,10)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit {
                        //확인버튼 메소드
                    }
                    .overlay {
                    HStack{
                        Spacer()
                        Button(action: {
                            //인증번호 발송 메소드
                            isAlert = true
                        }) {
                            Text("발송")
                                .font(.pretendardHeadline)
                                .foregroundColor(Color("Brown0"))
                        }
                        .buttonStyle(.bordered)
                        .tint(Color("Brown2"))
                    }
                }
                CustomDivider(isCorrectPhone)
                
                Text("인증번호")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
                    .padding(.top,10)
                
                TextField("휴대폰으로 발송한 인증번호를 입력해주세요", text: $authNumber)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .font(.pretendardCallout)
                    .padding(.top,10)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit {
                        //확인버튼 메소드
                    }
                    .overlay {
                    HStack{
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(isCorrectAuth ? Color("Brown0") : .clear )
                    }
                }
                CustomDivider(isCorrectAuth)
                HStack{
                    Text("인증번호가 오지 않는다면?")
                        .font(.pretendardFootnote)
                        .foregroundColor(.secondary)
                    Button(action: {}) {
                        Text("재발송")
                            .underline()
                            .font(.pretendardFootnoteBold)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            
            Button(action: {
                
                withAnimation(.easeInOut)  {
                    signUpState = .map
                }
            }) {
                Text("확인")
            }
            .buttonStyle(BasicBrownButton())
            .padding(.top,30)
            
            Spacer()
        }
        .padding(30)
        .alert("인증번호가 발송되었습니다.", isPresented: $isAlert, actions: {
            Button(action: {
                isAlert = false
            }) {
                Text("확인")
            }
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("회원가입")
                    .foregroundColor(Color("Brown0"))
                    .font(.pretendardHeadline)
            }
       }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    @State static var signUpState : SignUpState = .phone
    
    static var previews: some View {
        NavigationView{
            PhoneAuthView(signUpState: $signUpState)
        }
    }
}
