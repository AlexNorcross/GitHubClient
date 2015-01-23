//
//  ToUserViewController.swift
//  GitHubClient
//
//  Created by Alexandra Norcross on 1/21/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

import UIKit

class ToUserViewController: NSObject, UIViewControllerAnimatedTransitioning {
  //Function: Set transition animation duration.
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 1.0
  } //end func
  
  //Function: Set animation.
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    //From & To view controllers:
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SearchUserViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserViewController
    //Transition container:
    let containerView = transitionContext.containerView()
    
    //From cell: make snapshot and hide.
    let cellIndexPath = fromVC.collectionUsers.indexPathsForSelectedItems().first as NSIndexPath
    let cell = fromVC.collectionUsers.cellForItemAtIndexPath(cellIndexPath) as UserCollectionViewCell
    let cellSnapshot = cell.snapshotViewAfterScreenUpdates(false)
    cellSnapshot.frame = containerView.convertRect(cell.imageUser.frame, fromView: cell.imageUser.superview) //need coordinates in terms of container view
    cell.imageUser.hidden = true
    
    //To view controller: set frame and hide.
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.alpha = 0
    toVC.imageUser.hidden = true
    
    //Transition container: add subviews.
    containerView.addSubview(toVC.view)
    containerView.addSubview(cellSnapshot)
    
    //To view controller: run autolayout.
    toVC.view.setNeedsDisplay()
    toVC.view.layoutIfNeeded()
    
    //Animate and clean up.
    let duration = self.transitionDuration(transitionContext)
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1
      cellSnapshot.frame = containerView.convertRect(toVC.imageUser.frame, fromView: toVC.view)
    }) { (finished) -> Void in
      toVC.imageUser.hidden = false
      cell.imageUser.hidden = false
      cellSnapshot.removeFromSuperview()
      transitionContext.completeTransition(true)
    } //end closure
  } //end func
}