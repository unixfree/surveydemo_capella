import SwiftUI

struct MenuView: View {
    @Binding var selectedMenu: MenuOption
    @Binding var showMenu: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer().frame(height: 60) // 메뉴를 햄버거 버튼 아래로 내리기 위해 여백 추가

            Button(action: {
                selectedMenu = .home
                withAnimation { showMenu = false }
            }) {
                Text("Home")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                selectedMenu = .insertData
                withAnimation { showMenu = false }
            }) {
                Text("Insert Data")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                selectedMenu = .selectData
                withAnimation { showMenu = false }
            }) {
                Text("Select Data")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                selectedMenu = .serverSync
                withAnimation { showMenu = false }
            }) {
                Text("Server Sync")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(selectedMenu: .constant(.home), showMenu: .constant(true))
    }
}
