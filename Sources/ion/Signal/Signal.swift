import Foundation

protocol SignalDelegate: AnyObject {
//    func signal(_ signal: Signal, didReceiveTrickle trickle: Trickle)
//    func signal(_ signal: Signal, didReceiveDescription description: SessionDescription)
//    func signal(_ signal: Signal, didReceiveJoinReply join: JoinReply)
//    func signal(_ signal: Signal, failedWithError error: SignalingClient.Error)
}

protocol Signal {
    var delegate: SignalDelegate { get set }

    func join(session: String)
    func offer()
    func answer()
    func trickle()
    func close()
}
