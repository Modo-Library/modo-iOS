//
//  TestMainView.swift
//  NewModo
//
//  Created by MacBook on 2023/08/07.
//

import SwiftUI

struct TestMainView: View {
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(0..<10){ _ in
                    HStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: Screen.maxHeight*0.12,height: Screen.maxHeight*0.12)
                            .padding()
                        VStack(alignment: .leading){
                            HStack{
                                Text("데미안 서적 팔아요")
                                Spacer()
                                Image(systemName: "location.circle")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text("1km")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .padding(.trailing,10)
                                
                            }
                            
                            HStack{
                                Text("대여가능")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding(.horizontal,10)
                                    .background{
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(height: 20)
                                            .foregroundColor(Color("Brown3"))
                                    }
                                    .padding(.top,-5)
                            Spacer()
                            }
                            
                            Spacer()
                            HStack{
                                Spacer()
                                Text("20,000원")
                                    .bold()
                            }
                            
                        }
                        .frame(height: Screen.maxHeight*0.12)
                    }//HStack
                    .frame(height: Screen.maxHeight*0.15)
                    .padding(5)
                    Divider()
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color("Brown3"))
                        .font(.pretendardTitle3Bold)
                }
            }
        })
    }
}

struct TestMainView_Previews: PreviewProvider {
    static var previews: some View {
        TestMainView()
    }
}
