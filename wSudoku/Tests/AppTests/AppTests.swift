@testable import App
import XCTVapor

struct ResponseSudoku: Content {
    var sucess = false
    var message: String?
    var data = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
}

final class AppTests: XCTestCase {
    func testDoSudakuOK() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app.test(.POST, "resolveSudoku", beforeRequest: { req in
            try req.content.encode(["grid":[ [6,0,0,0,0,0,0,0,0],
                                             [0,0,3,1,5,0,0,7,0],
                                             [0,8,0,9,0,0,2,0,0],
                                             [0,9,7,0,0,0,0,0,0],
                                             [0,2,0,0,0,0,0,1,0],
                                             [0,0,0,0,0,0,8,5,0],
                                             [0,0,5,0,0,7,0,3,0],
                                             [0,1,0,0,2,8,6,0,0],
                                             [0,0,0,0,0,0,0,0,4] ]])
        }, afterResponse: { res in
 
            XCTAssertEqual(res.status, .ok)

            let solutionSudoku = try res.content.decode(ResponseSudoku.self)

            XCTAssertEqual(solutionSudoku.sucess, true)
        })
 
    }
    
    func testDoSudakuWrongData01() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app.test(.POST, "resolveSudoku", beforeRequest: { req in
            try req.content.encode(["grid":[ [6,0,0,0,0,0,0,0,0],
                                             [0,0,5,0,0,7,0],
                                             [0,8,0,9,0,0,2,0,0],
                                             [0,9,7,0,0,0,0,0,0],
                                             [0,2,0,0,0,0,0,1,0],
                                             [0,0,0,0,0,0,0,8,5,0],
                                             [0,0,5,0,0,7,0,3,0],
                                             [0,1,0,0,2,8,6,0,0],
                                             [0,0,0,0,0,0,0,0,4] ]])
        }, afterResponse: { res in
 
            XCTAssertEqual(res.status, .ok)

            let solutionSudoku = try res.content.decode(ResponseSudoku.self)

            XCTAssertEqual(solutionSudoku.sucess, false)
        })
 
    }
    
    func testDoSudakuWrongData02() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
 
        try app.test(.POST, "resolveSudoku", beforeRequest: { req in
            try req.content.encode(["grid":[ [6,0,0,0,0,0,0,0,0],
                                             [0,0,3,1,5,0,0,7,0],
                                             [0,8,0,9,0,0,2,0,0],
                                             [0,9,7,0,0,0,0,0,0],
                                             [0,2,0,0,0,0,0,1,0],
                                             [0,0,0,0,0,0,8,5,0],
                                             [0,0,5,0,0,7,0,3,0],
                                             [0,1,0,0,2,8,6,0,0],
                                             [0,1,0,0,2,8,6,0,0],
                                             [0,0,0,0,0,0,0,0,4] ]])
        }, afterResponse: { res in
 
            XCTAssertEqual(res.status, .ok)

            let solutionSudoku = try res.content.decode(ResponseSudoku.self)

            XCTAssertEqual(solutionSudoku.sucess, false)
        })
 
    }
}



