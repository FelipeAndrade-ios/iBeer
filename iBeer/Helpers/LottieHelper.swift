//
//  LottieHelper.swift
//  iBeer
//
//  Created by Felipe Andrade on 25/02/21.
//

import UIKit
import Lottie

public class LottieHelper {
    public static func setLoopAnimation(name: String, on view: UIView, animator: AnimationView) {
        if let path = Bundle.main.path(forResource: name,
                                       ofType: "json") {
            animator.animation = Animation.filepath(path)
            animator.frame = CGRect(origin: .zero, size: view.bounds.size)
            view.insertSubview(animator, at: 0)
            animator.play(fromProgress: .none, toProgress: .greatestFiniteMagnitude,
                          loopMode: .loop, completion: nil)
        }
    }
    
    public static func setLoopAnimation(name: String, on view: UIView, animator: AnimationView, aspectRatio: CGFloat) {
        if let path = Bundle.main.path(forResource: name,
                                       ofType: "json") {
            animator.animation = Animation.filepath(path)
            animator.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.height*aspectRatio,
                                                                           height: view.bounds.height))
            view.addSubview(animator)
            animator.play(fromProgress: .none, toProgress: .greatestFiniteMagnitude,
                                   loopMode: .loop, completion: nil)
        }
    }
    
    public static func play(_ view: AnimationView) {
        view.play(fromProgress: .none, toProgress: .greatestFiniteMagnitude,
                       loopMode: .loop, completion: nil)
    }
    
    public static func playOnce(_ view: AnimationView) {
        view.play(fromProgress: .none, toProgress: .greatestFiniteMagnitude,
                  loopMode: .playOnce, completion: nil)
    }
}
