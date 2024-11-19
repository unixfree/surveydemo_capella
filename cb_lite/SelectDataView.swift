import SwiftUI
import CouchbaseLiteSwift

// MyData 구조체 정의
struct MyData: Identifiable {
    var id: String // Couchbase 문서의 key (ID)
    var gender: String
    var age: String
    var visit: String
    var visitReason: String
    var rating: String
    var text: String
}

struct SelectDataView: View {
    @State private var documents: [MyData] = [] // 조회한 문서 목록
    @State private var selectedOption: String = "All" // 필터 옵션 선택
    @State private var documentID: String = "" // 조회할 ID

    var body: some View {
        VStack {
            Text("저장된 데이터 조회")
                .font(.title)
                .padding(.top, 20)

            // 필터 옵션 선택
            Picker("옵션 선택", selection: $selectedOption) {
                Text("All").tag("All")
                Text("ID로 조회").tag("ID")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // ID 입력 필드 (ID 조회 옵션 선택 시에만 표시)
            if selectedOption == "ID" {
                TextField("ID 입력", text: $documentID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }

            Button(action: fetchData) {
                Text("조회")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            // 조회된 데이터 리스트
            List(documents) { data in
                VStack(alignment: .leading) {
                    Text("ID: \(data.id)") // 문서 ID 표시
                        .font(.headline)
                    Text("성별: \(data.gender)")
                    Text("연령대: \(data.age)")
                    Text("방문 횟수: \(data.visit)")
                    Text("방문 이유: \(data.visitReason)")
                    Text("만족도: \(data.rating)")
                    Text("추가 의견: \(data.text)")
                }
                .padding()
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    // 데이터 조회 함수
    func fetchData() {
        do {
            let database = try Database(name: "sync_test")
            let collection = try database.createCollection(name: "sync", scope: "test")

            var query: Query

            // 필터 옵션에 따른 쿼리 설정
            if selectedOption == "All" {
                query = QueryBuilder
                    .select(SelectResult.all(), SelectResult.expression(Meta.id)) // Meta.id 포함
                    .from(DataSource.collection(collection))
            } else {
                query = QueryBuilder
                    .select(SelectResult.all(), SelectResult.expression(Meta.id)) // Meta.id 포함
                    .from(DataSource.collection(collection))
                    .where(Meta.id.equalTo(Expression.string(documentID)))
            }

            // 쿼리 실행 및 결과를 배열로 변환
            let result = try query.execute()
            documents = result.allResults().compactMap { result in
                let dict = result.dictionary(forKey: "sync")
                return MyData(
                    id: result.string(forKey: "id") ?? "N/A", // Meta.id 값을 id 필드로 설정
                    gender: dict?.string(forKey: "gender") ?? "N/A",
                    age: dict?.string(forKey: "age") ?? "N/A",
                    visit: dict?.string(forKey: "visit") ?? "N/A",
                    visitReason: dict?.string(forKey: "visitReason") ?? "N/A",
                    rating: dict?.string(forKey: "rating") ?? "N/A",
                    text: dict?.string(forKey: "text") ?? "N/A"
                )
            }
            
            print("데이터가 성공적으로 조회되었습니다.")
        } catch {
            print("데이터 조회 실패: \(error.localizedDescription)")
        }
    }
}
