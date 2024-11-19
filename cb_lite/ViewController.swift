import UIKit
import CouchbaseLiteSwift

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDatabase()
    }

    func initializeDatabase() {
        do {
            let database = try Database(name: "mydb")
            // 데이터베이스 작업 수행
        } catch {
            print("데이터베이스 초기화 오류: \(error.localizedDescription)")
        }
    }
    func createDocument(in database: Database) {
        let mutableDoc = MutableDocument()
            .setFloat(2.0, forKey: "version")
            .setString("SDK", forKey: "type")

        do {
            try database.saveDocument(mutableDoc)
            print("문서 생성: ID = \(mutableDoc.id), type = \(mutableDoc.string(forKey: "type")!)")
        } catch {
            print("문서 저장 오류: \(error.localizedDescription)")
        }
    }
    func updateDocument(in database: Database, documentID: String) {
        guard let document = database.document(withID: documentID)?.toMutable() else { return }
        document.setString("Swift", forKey: "language")

        do {
            try database.saveDocument(document)
            print("문서 업데이트: ID = \(document.id), language = \(document.string(forKey: "language")!)")
        } catch {
            print("문서 업데이트 오류: \(error.localizedDescription)")
        }
    }
    func queryDocuments(in database: Database) {
        let query = QueryBuilder
            .select(SelectResult.all())
            .from(DataSource.database(database))
            .where(Expression.property("type").equalTo(Expression.string("SDK")))

        do {
            let result = try query.execute()
            print("조회된 문서 수: \(result.allResults().count)")
        } catch {
            print("문서 조회 오류: \(error.localizedDescription)")
        }
    }



}
