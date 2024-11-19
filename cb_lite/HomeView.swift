import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("couchbase_logo") // 로고 이미지
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Couchbase Sync Test App")
                .font(.title)
                .padding(.top, 20)
            
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
