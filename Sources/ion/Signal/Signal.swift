import Foundation

protocol SignalDelegate: AnyObject {
    func signal(_ signal: Signal, didReceiveTrickle trickle: Trickle)
    func signal(_ signal: Signal, didReceiveDescription description: SessionDescription)
//    func signal(_ signal: Signal, didReceiveJoinReply join: JoinReply)
//    func signal(_ signal: Signal, failedWithError error: Error)
}

protocol Signal {
    var delegate: SignalDelegate { get set }

    func join(session: String, description: SessionDescription)
    func offer(_ description: SessionDescription)
    func answer(_ description: SessionDescription)
    func trickle(_ trickle: Trickle)
    func close()
}
