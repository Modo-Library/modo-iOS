//
//  MapAuthView.swift
//  Modo
//
//  Created by MacBook on 2023/04/27.
//

import SwiftUI

struct MapAuthView: View {
    @Binding var signUpState : SignUpState
    
    @State var cameraPosition: LatLng = (0,0)//(126.984996, 37.561059)// 현 기기값
    @State var circleTapped: Bool = false
    
    @ObservedObject var reverseGeocodeVM : ReverseGeocodeViewModel = Coordinator.shared.reverseGeocodeVM
    
    var body: some View {
        VStack(alignment: .leading){
            Group{
                Text("위치인증")
                    .font(.pretendardTitle)
                    .padding(.top,10)
                
                Text("사용할 도서관 위치를 선택해주세요")
                    .font(.pretendardFootnote)
                    .foregroundColor(.secondary)
            }
            //네이버맵
            ZStack{
                NaverMap(cameraPosition: $cameraPosition)
                    .frame(height: Screen.maxHeight*0.4)
                    .cornerRadius(15)
                Image("marker0")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
            }
            .padding(.top,30)
            AddressView()
                .padding(.top,30)
            
            Button(action: {
                withAnimation(.easeInOut)  {
                    signUpState = .detail
                }
            }) {
                Text("위치 인증 완료")
            }
            .buttonStyle(BasicBrownButton())
            .padding(.top,30)
            
            
        }
        .padding(30)
        .onAppear{
            Coordinator.shared.checkIfLocationServicesIsEnabled()
            cameraPosition = Coordinator.shared.userLocation
        }
        
        
    }
    // MARK: - 카메라 위치 위도 경도 에 대한 실주소 반환 텍스트
    @ViewBuilder
    private func AddressView() -> some View {
        VStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.gray))
                .opacity(0.1)
                .frame(height: 35)
                .overlay {
                    Text("\(Coordinator.shared.currentAddress)")
                        .font(.pretendardCallout)
                        .foregroundColor(.secondary)
                        .padding(8)
                }
        }
    }
    
}

struct MapAuthView_Previews: PreviewProvider {
    @State static var signUpState : SignUpState = .map
    
    static var previews: some View {
        MapAuthView(signUpState: $signUpState)
    }
}
