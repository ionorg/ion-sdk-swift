import Foundation

struct ICECandidate {
    let candidate: String
    let sdpMid: String
    let sdpMLineIndex: Int
    let usernameFragment: String
}

struct Trickle {
    let target: Role
    let candidate: ICECandidate
}
