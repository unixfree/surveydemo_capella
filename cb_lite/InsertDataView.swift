import SwiftUI
import CouchbaseLiteSwift

struct InsertDataView: View {
    @State private var documentID: String = "" // 사용자가 입력하거나 생성된 ID 값을 저장
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var visit: String = ""
    @State private var visitReason: String = ""
    @State private var otherReason: String = ""
    @State private var rating: String = ""
    @State private var text: String = ""
    @State private var showIDWarning = false // ID가 비어 있을 때 경고 메시지 표시 여부

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("설문조사")
                        .font(.title)

                    // 문서 ID 필드: 사용자 입력 또는 자동 생성
                    TextField("문서 ID 입력 또는 자동 생성", text: $documentID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("새 문서 ID 생성") {
                        documentID = generateRandomString(length: 8)
                    }
                    .padding(.horizontal)

                    // ID 경고 메시지
                    if showIDWarning {
                        Text("ID를 입력하세요.")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Text("성별")
                    Picker("성별", selection: $gender) {
                        Text("남성").tag("남")
                        Text("여성").tag("여")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Text("연령대")
                    Picker("연령대", selection: $age) {
                        Text("10대").tag("10대")
                        Text("20대").tag("20대")
                        Text("30대").tag("30대")
                        Text("40대").tag("40대")
                        Text("50대 이상").tag("50대 이상")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Text("방문 횟수")
                    Picker("방문 횟수", selection: $visit) {
                        Text("처음").tag("처음")
                        Text("2~3회").tag("2~3회")
                        Text("4~5회").tag("4~5회")
                        Text("6회 이상").tag("6회 이상")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Text("방문 이유")
                    Picker("방문 이유", selection: $visitReason) {
                        Text("매장 앞을 지나다 눈에 띄어서").tag("매장 앞을 지나다 눈에 띄어서")
                        Text("지역신문이나 광고를 통해 알게 되어서").tag("지역신문이나 광고를 통해 알게 되어서")
                        Text("지인의 권유로").tag("지인의 권유로")
                        Text("기타").tag("기타")
                    }
                    if visitReason == "기타" {
                        TextField("기타 사유", text: $otherReason)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    Text("만족도 평가")
                    Picker("만족도", selection: $rating) {
                        Text("매우 만족").tag("매우 만족")
                        Text("만족").tag("만족")
                        Text("보통").tag("보통")
                        Text("불만족").tag("불만족")
                        Text("매우 불만족").tag("매우 불만족")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Text("추가 의견")
                    TextField("추가 의견을 입력하세요", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
            }

            Button(action: submitData) {
                Text("제출")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }

    // 랜덤 문자열 생성 함수
    func generateRandomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
    
    // 데이터 제출 함수
    func submitData() {
        // ID 유효성 검사: 입력된 ID가 비어 있을 경우 경고 표시
        guard !documentID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showIDWarning = true
            return
        }
        
        showIDWarning = false // ID가 비어 있지 않으면 경고 해제

        do {
            let database = try Database(name: "sync_test")
            let collection = try database.createCollection(name: "sync", scope: "test")

            // 기존 문서가 있으면 업데이트, 없으면 새로 저장
            let document = MutableDocument(id: documentID)
            document.setString(gender, forKey: "gender")
            document.setString(age, forKey: "age")
            document.setString(visit, forKey: "visit")
            document.setString(visitReason == "기타" ? otherReason : visitReason, forKey: "visitReason")
            document.setString(rating, forKey: "rating")
            document.setString(text, forKey: "text")
            document.setDate(Date(), forKey: "createdAt")

            // 데이터 저장
            try collection.save(document: document)
            print("데이터가 성공적으로 저장되었습니다.")
            
            // 폼 초기화
            resetForm()
            documentID = ""
        } catch {
            print("데이터 저장 실패: \(error.localizedDescription)")
        }
    }

    // 폼 초기화 함수
    func resetForm() {
        gender = ""
        age = ""
        visit = ""
        visitReason = ""
        rating = ""
        otherReason = ""
        text = ""
    }
}
