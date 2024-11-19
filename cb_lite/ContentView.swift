import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    @State private var selectedMenu: MenuOption = .home

    var body: some View {
        ZStack(alignment: .leading) {
            // 메인 콘텐츠
            VStack(spacing: 0) {
                // 상단 바
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) { showMenu.toggle() }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Couchbase 클릭 시 홈으로 이동
                    Button(action: {
                        selectedMenu = .home // Couchbase 텍스트 클릭 시 홈으로 이동
                        showMenu = false
                    }) {
                        Text("Couchbase")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // 오른쪽 공간 비워둠 (버튼 균형 맞추기)
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.clear) // 투명 버튼
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 2)
                .cornerRadius(15)
                
                Spacer()
                
                // 메인 콘텐츠
                mainView
                    .padding()
            }
            
            // 슬라이드 메뉴
            if showMenu {
                ZStack(alignment: .leading) {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) { showMenu = false }
                        }
                    
                    MenuView(selectedMenu: $selectedMenu, showMenu: $showMenu)
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                        .background(Color.white)
                        .offset(x: showMenu ? 0 : -UIScreen.main.bounds.width * 0.5)
                        .animation(.easeInOut(duration: 0.3), value: showMenu)
                }
            }
        }
    }

    // 메인 화면 콘텐츠
    private var mainView: some View {
        Group {
            switch selectedMenu {
            case .home:
                HomeView()
            case .insertData:
                InsertDataView()
            case .selectData:
                SelectDataView()
            case .serverSync:
                ServerSyncView()
            }
        }
    }
}
