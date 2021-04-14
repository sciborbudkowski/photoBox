//
//  ModalViewController.swift
//  photoBox
//
//  Created by Ścibor Budkowski on 14/04/2021.
//

import UIKit
import Jelly

class ModalViewController {
    
    static func show(_ viewController: UIViewController, modal: UIViewController, size: CGFloat) {
        let allCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        let uiConfiguration = PresentationUIConfiguration(cornerRadius: 10,
                                                          backgroundStyle: .dimmed(alpha: 0.7),
                                                          isTapBackgroundToDismissEnabled: true,
                                                          corners: allCorners)
        
        let alignment = PresentationAlignment(vertical: .bottom, horizontal: .center)
        let marginGuards = UIEdgeInsets(top: 40, left: 10, bottom: 40, right: 10)
        let timing = PresentationTiming(duration: .normal, presentationCurve: .linear, dismissCurve: .linear)
        var sizing: PresentationSize
        if DeviceOrientation.isPortrait() {
            sizing = PresentationSize(width: .fullscreen, height: .custom(value: size))
        }
        else {
            sizing = PresentationSize(width: .halfscreen, height: .custom(value: size))
        }
        let interactionConfiguration = InteractionConfiguration(presentingViewController: viewController.self,
                                                                completionThreshold: 1.0,
                                                                dragMode: .canvas)
        
        let presentation = CoverPresentation(directionShow: .bottom,
                                             directionDismiss: .bottom,
                                             uiConfiguration: uiConfiguration,
                                             size: sizing,
                                             alignment: alignment,
                                             marginGuards: marginGuards,
                                             timing: timing,
                                             spring: .none,
                                             interactionConfiguration: interactionConfiguration)
        
        let animator = Animator(presentation: presentation)
        animator.prepare(presentedViewController: modal)
        viewController.present(modal, animated: true)
    }
}
