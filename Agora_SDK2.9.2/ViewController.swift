//
//  ViewController.swift
//  Agora_SDK2.9.3
//
//  Created by Bac Cheng Huang on 2021/7/6.
//


import UIKit
import AgoraRtcEngineKit

class ViewController: UIViewController {

 
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var localView: UIView!
    var appId: String = ""
    var channelName: String = "Agora_Test"
    
    var agoraKit: AgoraRtcEngineKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        initializeAgoreEngine()
        setupLocalVideo()
        joinChannel()
        
        
        // TEST audio mixing
        let filePath = ""
        let loopback = false
        let replace = false
        let cycle = 1
        
        // Starts to play the music file.
        agoraKit?.startAudioMixing(filePath, loopback: loopback, replace: replace, cycle: cycle)

    }

    // Occurs when the state of the local user's music file changes.
    func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioMixingStateDidChanged state: AgoraAudioMixingStateCode) {
        print("CHICKEN NUGGEST \(state)");
    }
    
    func initializeAgoreEngine(){
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
    }
    
    func setupLocalVideo(){
        agoraKit?.enableVideo()
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel(){
        agoraKit?.joinChannel(byToken: "", channelId: channelName, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
            print("successfully joined channel \(channel)")
        })
    }
    
    func leaveChannel(){
        agoraKit?.leaveChannel(nil)
        localView.isHidden = true
        remoteView.isHidden = true
    }
    
    
    @IBAction func didTapHangUp(_ sender: UIButton) {
        leaveChannel()
    }
    
    
    
}

extension ViewController: AgoraRtcEngineDelegate{
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int){
//
//    }
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int) {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.view = remoteView
//        videoCanvas.renderMode = .hidden
//
//        agoraKit?.setupRemoteVideo(videoCanvas)
//    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
