import SwiftUI
import CouchbaseLiteSwift

struct ServerSyncView: View {
    @State private var showToast = false // 토스트 메시지 표시 여부

    var body: some View {
        VStack {
            Spacer()

            Text("Server Sync")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            Button(action: {
                syncData()
            }) {
                Text("Sync Data")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .toast(isPresented: $showToast, message: "Sync Complete") // 토스트 메시지
    }
    
    // 데이터 동기화 함수
    func syncData() {
        do {
            let database = try Database(name: "sync_test")
            let collection = try database.createCollection(name: "sync", scope: "test")
            
            // 데이터베이스 경로 출력
            if let dbPath = database.path {
                            print("데이터베이스 경로: \(dbPath)")
                        } else {
                            print("데이터베이스 경로를 찾을 수 없습니다.")
                        }
            
            // 서버 엔드포인트 설정 (요청하신 URL로 수정)
            let target = URLEndpoint(url: URL(string: "wss://4qo2iwqqtdjhj1gl.apps.cloud.couchbase.com:4984/demo")!)
            var replConfig = ReplicatorConfiguration(target: target)
            
            // 컬렉션 및 기본 충돌 해결 방식 추가
            replConfig.addCollection(collection)
            replConfig.authenticator = BasicAuthenticator(username: "sync_gateway", password: "Password12!@")
            replConfig.replicatorType = .pushAndPull
            

            // 동기화 시작
            let replicator = Replicator(config: replConfig)

            replicator.addChangeListener { (change) in
                if let error = change.status.error as NSError? {
                    print("동기화 오류 발생: \(error.localizedDescription)")
                } else {
                    print("동기화 상태: \(change.status.activity) - 완료 문서 수: \(change.status.progress.completed) / 총 문서 수: \(change.status.progress.total)")
                }
            }

            replicator.start()

            // 동기화 완료 후 토스트 메시지 표시
            showToast = true
        } catch {
            print("동기화 실패: \(error.localizedDescription)")
        }
    }
}
