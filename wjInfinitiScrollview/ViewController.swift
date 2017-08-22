//
//  ViewController.swift
//  wjInfinitiScrollview
//
//  Created by jerry on 2017/8/22.
//  Copyright © 2017年 wangjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    lazy var scrollView : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.frame = CGRect(x: 33.5, y: 58.5, width: 300, height: 550)
        scrollview.isPagingEnabled = true
        scrollview.bounces = false
        scrollview.showsHorizontalScrollIndicator = false
        return scrollview
    }()
    
    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.cyan
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPage = 0
        pageControl.frame = CGRect(x: 33.5, y: 570, width: 300, height: 30)
        return pageControl
    }()
    
    lazy var imgArray : [String] = {
        let arr = NSArray(contentsOfFile: Bundle.main.path(forResource: "imageArray", ofType: "plist")!) as! [String]
        return arr
    }()
    
    var timer : Timer!
    var tempPage : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imgArray)
        wjSetUpUI()
        wjStartTimer()
    }
}

extension ViewController {
    func wjStartTimer() {
        timer = Timer(timeInterval: 1.5, target: self, selector: #selector(self.wjStartAutoScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    
    func wjStopTimer()  {
        timer.invalidate()
        timer = nil
    }
}


extension ViewController {
    
    func wjSetUpUI() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        
        // 添加第一张照片
        let firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        firstImageView.image = UIImage(named: imgArray.last!)
        scrollView.addSubview(firstImageView)
        
        // 添加正常的图片
        for idx in 0..<imgArray.count {
            let rect = CGRect(x: CGFloat(idx + 1) * width, y: 0, width: width, height: height)
            let imageView = UIImageView(frame: rect)
            imageView.image = UIImage(named: imgArray[idx])
            scrollView.addSubview(imageView)
        }
        
        // 添加最后一张图
        let lastImageViwe = UIImageView(frame: CGRect(x: CGFloat(imgArray.count + 1) * width, y: 0, width: width, height: height))
        lastImageViwe.image = UIImage(named: imgArray.first!)
        scrollView.addSubview(lastImageViwe)
    
        scrollView.contentSize = CGSize(width: CGFloat(imgArray.count + 2) * width, height: height)
        scrollView.contentOffset = CGPoint(x: width, y: 0)
    
        // pageControl
        pageControl.numberOfPages = imgArray.count
        view.addSubview(pageControl)
    }
}

extension ViewController : UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        wjStopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        wjStartTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let page = Int(scrollView.contentOffset.x / width + 0.5)
//        print(" did scroll  \(page)")
        pageControl.currentPage = page - 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        var page = Int(scrollView.contentOffset.x / width + 0.5)
        print(page)
        if page == 0 {
            page = imgArray.count
        } else if page == imgArray.count + 1 {
            page = 1
        }
        scrollView.contentOffset = CGPoint(x: CGFloat(page) * width, y: 0)
    }
    
    // MARK:- 自动轮播
    func wjStartAutoScroll() {
        // 6 1 2 3 4 5 6 1
        // 1 2 3 4 5 6
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        let page = pageControl.currentPage + 1
//        print(" auto scroll \(page)")
        tempPage = page
        scrollView.scrollRectToVisible(CGRect(x: CGFloat(page + 1) * width, y: 0, width: width, height: height), animated: true)
        self.pageControl.currentPage = page
    }
    
    // 让无线轮播更加顺畅，到第六张的时候，回到第一张的偏移量处
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        if tempPage == 0 {
            scrollView.scrollRectToVisible(CGRect(x: CGFloat(imgArray.count) * width, y: 0, width: width, height: height), animated: false)
        } else if tempPage == imgArray.count {
            scrollView.scrollRectToVisible(CGRect(x: width, y: 0, width: width, height: height), animated: false)
        }
    }
}




