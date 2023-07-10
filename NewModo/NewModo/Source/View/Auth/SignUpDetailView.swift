//
//  SignUpView.swift
//  Modo
//
//  Created by MacBook on 2023/03/25.
//
import SwiftUI

private enum FocusableField: Hashable {
    case email
    case pw
    case checkPw
    case name
}

struct SignUpDetailView: View {
    @ObservedObject var signUpVM = SignUpViewModel()
    @FocusState private var focus : FocusableField?
    
    @Binding var signUpState : SignUpState
    
    @State private var checkPw : String = ""
    @State private var isDuplicatedBtnTapped = false
    @State private var isDuplicated = true
    @State private var isShowingPw = false
    @State private var isShowingCheckPw = false
    
    //연산프로퍼티
    
    private var isCorrectEmail: Bool {
        for c in signUpVM.email {
            if c == "@"{
                return true
            }
        }
        return false
    }
    
    private var isNotIncludedEnglish:  Bool {
        for c in signUpVM.pw {
            if c.isLetter {
                return true
            }
        }
        return false
    }
    private var isNotIncludedNumber:  Bool {
        for c in signUpVM.pw {
            if c.isNumber {
                return true
            }
        }
        return false
    }
    private var isNotLimitedLength:  Bool {
        if signUpVM.pw.count < 8 || signUpVM.pw.count > 20 {
            return false
        }
        return true
    }
    
    private var isPwSameCheck : Bool {
        if !isNotIncludedEnglish || !isNotIncludedNumber || !isNotLimitedLength {
            return false
        }else {
            if signUpVM.pw == checkPw {
                return true
            }else{
                return false
            }
        }
    }
    
    private var isCorrectName: Bool {
        if signUpVM.name.count > 1 {
            return true
        }
        return false
    }
    
    // MARK: - SignUpView
    var body: some View {
        VStack(alignment: .leading){
            // MARK: - 이메일 입력 뷰
            Group{
                Text("이메일")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
                    .padding(.top,10)
                HStack{
                    VStack{
                        TextField("이메일", text: $signUpVM.email)
                            .focused($focus, equals: .email)
                            .textFieldStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(.top,10)
                        
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                self.focus = .pw
                            }
                            .overlay {
                                HStack{
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(isCorrectEmail ? Color("Brown0") : .clear )
                                }
                            }
                        
                        
                        CustomDivider(isCorrectEmail)
                    }
                }//HStack
            }
            
            // MARK: - 비밀번호 입력 뷰
            Group{
                Text("비밀번호")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
                    .padding(.top,10)
                
                if isShowingPw {
                    TextField("비밀번호", text: $signUpVM.pw)
                        .focused($focus, equals: .pw)
                        .font(.pretendardCallout)
                        .textFieldStyle(.plain)
                        .frame(height: 20)
                        .padding(.top,10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            self.focus = .checkPw
                        }
                        .overlay {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isShowingPw.toggle()
                                    }) {
                                        Image(systemName: isShowingPw ? "eye.slash": "eye")
                                    }
                                    .foregroundColor(.secondary)
                                }
                        }
                }else{
                    SecureField("비밀번호 확인", text: $signUpVM.pw)
                            .focused($focus, equals: .pw)
                            .font(.pretendardCallout)
                            .textFieldStyle(.plain)
                            .frame(height: 20)
                            .padding(.top,10)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                self.focus = .checkPw
                            }
                            .overlay {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isShowingPw.toggle()
                                    }) {
                                        Image(systemName: isShowingPw ? "eye.slash": "eye")
                                    }
                                    .foregroundColor(.secondary)
                                }
                            }
                    }
                    CustomDivider(isNotIncludedEnglish && isNotIncludedNumber && isNotLimitedLength)
                            
            }
            
            // MARK: - 비밀번호 확인 입력 뷰
            Group{
                Text("비밀번호 확인")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
                    .padding(.top,10)
                
                if isShowingCheckPw {
                    TextField("비밀번호 확인", text: $checkPw)
                        .focused($focus, equals: .checkPw)
                        .font(.pretendardCallout)
                        .textFieldStyle(.plain)
                        .frame(height: 20)
                        .padding(.top,10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            self.focus = .name
                        }
                        .overlay {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isShowingCheckPw.toggle()
                                    }) {
                                        Image(systemName: isShowingCheckPw ? "eye.slash": "eye")
                                    }
                                    .foregroundColor(.secondary)
                                }
                        }
                }else{
                    SecureField("비밀번호 확인", text: $checkPw)
                            .focused($focus, equals: .checkPw)
                            .font(.pretendardCallout)
                            .textFieldStyle(.plain)
                            .frame(height: 20)
                            .padding(.top,10)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                self.focus = .name
                            }
                            .overlay {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isShowingCheckPw.toggle()
                                    }) {
                                        Image(systemName: isShowingCheckPw ? "eye.slash": "eye")
                                    }
                                    .foregroundColor(.secondary)
                                }
                            }
                    }
                CustomDivider(isPwSameCheck)
            }
            
            
            // MARK: - 닉네임 입력 뷰
            Group{
                Text("닉네임")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
                    .padding(.top,10)
                
                TextField("사용하실 닉네임을 입력해주세요", text: $signUpVM.name)
                    .focused($focus, equals: .name)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.top,10)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit {
                        //확인버튼 메소드
                    }
                    .overlay {
                        HStack{
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(isCorrectName ? Color("Brown0") : .clear )
                        }
                    }
                CustomDivider(isCorrectName)
            }
            
            //customNavLink(to: EmptyView(), title: nil)
            
            Button(action: {
                withAnimation(.easeInOut)  {
                    signUpState = .complete
                }
            }) {
                Text("확인")
            }
                .buttonStyle(BasicBrownButton())
                .padding(.top,30)
            Spacer()
        }
        .padding(30)
        
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("회원가입")
                    .foregroundColor(Color("Brown0"))
                    .font(.headline)
            }
        }
        .onAppear{
            focus = .email
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

/// by 조건에 따라 색깔이 바뀌는 Custom Divider
@ViewBuilder
func CustomDivider(_ by : Bool) -> some View {
    Rectangle().frame(height:by ? 2 : 1)
        .foregroundColor(by ? Color("Brown0") : .secondary)
}


struct SignUpDetailView_Previews: PreviewProvider {
    @State static var signUpState : SignUpState = .detail
    static var previews: some View {
        NavigationView{
            SignUpDetailView(signUpState: $signUpState)
        }
    }
}
