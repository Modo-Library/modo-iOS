//
//  ContentView.swift
//  Modo
//
//  Created by MacBook on 2023/03/22.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection : Int = 0
    var body: some View {
        NavigationStack{
            TabView(selection: $tabSelection) {
                HomeView()
                    .padding(.bottom,5)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                            .foregroundColor(Color("Brown1"))
                            .padding()
                    }
                StatusView()
                    .padding(.bottom,5)
                    .tag(1)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("대여현황")
                    }
                ChatView()
                    .padding(.bottom,5)
                    .tag(2)
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right")
                        Text("채팅")
                    }
                LikeView()
                    .padding(.bottom,5)
                    .tag(3)
                    .tabItem {
                        Image(systemName: "heart")
                        Text("찜")
                    }
                ProfileView()
                    .padding(.bottom,5)
                    .tag(4)
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("프로필")
                    }
            }//TabView
            .tint(Color("Brown1"))
            .navigationBarTitle(titleForSelectedTab(tabSelection),displayMode: .inline)
        }//NavigationView
        
    }
    
    func titleForSelectedTab(_ selectedTab: Int) -> String {
        // 선택된 탭에 따라 다른 타이틀을 반환하는 로직
        switch selectedTab {
        case 1:
            return "대여현황"
        case 2:
            return "채팅"
        case 3:
            return "찜 목록"
        case 4:
            return "프로필"
        default:
            return ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
