//
//  StretchyLayoutViewController.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 11/11/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import UIKit
import WebKit

extension UIImageView {
    
    public func addPlayButton(target:Any?, onPlayVideoAction: Selector) -> UIButton{
        let playBtn = UIButton()
        playBtn.isUserInteractionEnabled = true
        playBtn.setImage(UIImage(named: "play-icon"), for: .normal)
        playBtn.frame.size = CGSize(width: 100, height: 80)
        playBtn.backgroundColor = #colorLiteral(red: 0.2961424197, green: 0.2388503592, blue: 0.2352511523, alpha: 0.8033395687)
        playBtn.layer.cornerRadius = 4.0
        playBtn.addTarget(target, action: onPlayVideoAction, for: .touchUpInside)
        playBtn.isHidden = false
        
        self.isUserInteractionEnabled = true
        self.addSubview(playBtn)
        
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        return playBtn
    }
}

class StretchyLayoutViewController : UIViewController, UIScrollViewDelegate, WKNavigationDelegate  {
    
    private let imageRatio:CGFloat = 0.56
    
    private let scrollView = UIScrollView()
    
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    private let playBtn = UIButton()
    
    private let articleContainer = UIView()
    private let articleTitle = UILabel()
    private let articleTime = UILabel()
    private let articleText = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .always
        
        imageContainer.backgroundColor = .darkGray
        //imageView.image = UIImage(named: "118496_video")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        articleContainer.backgroundColor = .clear
        //articleContainer.backgroundColor = .green
        
        articleText.navigationDelegate = self
        
        articleTitle.textColor = .black
        articleTitle.numberOfLines = 0
        articleTitle.lineBreakMode = .byTruncatingTail
        articleTitle.font = UIFont.boldSystemFont(ofSize: 15)
        
        articleTime.text = "--:--"
        articleTime.textColor = .gray
        articleTime.font = UIFont.boldSystemFont(ofSize: 12)
        
        playBtn.isUserInteractionEnabled = true
        playBtn.setImage(UIImage(named: "play-icon"), for: .normal)
        playBtn.frame.size = CGSize(width: 100, height: 80)
        playBtn.backgroundColor = #colorLiteral(red: 0.2961424197, green: 0.2388503592, blue: 0.2352511523, alpha: 0.8033395687)
        playBtn.layer.cornerRadius = 4.0
        playBtn.addTarget(self, action: #selector(onPlayVideo(sender:)), for: .touchUpInside)
        playBtn.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageContainer)
        scrollView.addSubview(imageView)
        scrollView.addSubview(playBtn)
        
        scrollView.addSubview(articleContainer)
        articleContainer.addSubview(articleTitle)
        articleContainer.addSubview(articleTime)
        articleContainer.addSubview(articleText)
    }
    
    func updateArticleDetail(title:String, time:String, textAsHtml:String){
        articleTime.text = time
        articleTitle.text = title
        articleText.loadHTMLString(textAsHtml, baseURL: nil)
    }
    
    func updateArticleImage(image:UIImage){
        imageView.image = image
    }
    
    func allowPlayVideo(allowPlay:Bool){
        playBtn.isHidden = !allowPlay
    }
    
    @objc func onPlayVideo(sender: UIButton){
        print("play button")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            print("link")
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        print("no link")
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.scrollIndicatorInsets = view.safeAreaInsets
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        setupLayoutContraints()
        updateScrollViewContentSize()
    }
    
    private func setupLayoutContraints(){
        //view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        articleContainer.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleText.translatesAutoresizingMaskIntoConstraints = false
        articleTime.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         scrollView.snp.makeConstraints {
         make in
         make.edges.equalTo(view)
         }*/
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        
        /* imageContainer.snp.makeConstraints {
         make in
         
         make.top.equalTo(scrollView)
         make.left.right.equalTo(view)
         make.height.equalTo(imageContainer.snp.width).multipliedBy(0.7)
         }*/
        
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0),
            imageContainer.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0.0),
            imageContainer.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0.0),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: imageRatio)
        ])
        
         /*imageView.snp.makeConstraints {
         make in
         
         make.left.right.equalTo(imageContainer)
         
         // Note the priorities
         make.top.equalTo(view).priority(.high)
         
         // We add a height constraint too
         make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
         
         // And keep the bottom constraint
         make.bottom.equalTo(imageContainer.snp.bottom)
         }*/
        let topConstraint = imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0.0)
        topConstraint.priority = .defaultHigh

        let heightConstraint = imageView.heightAnchor.constraint(greaterThanOrEqualTo: imageContainer.heightAnchor, multiplier: 1.0)
        heightConstraint.priority = .required

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: imageContainer.leftAnchor, constant: 0.0),
            imageView.rightAnchor.constraint(equalTo: imageContainer.rightAnchor, constant: 0.0),
            topConstraint,
            heightConstraint,
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 0.0)
        ])
        
        // Play button
        NSLayoutConstraint.activate([
            playBtn.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playBtn.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            ])
        
        /*
         articleContainer.snp.makeConstraints {
         make in
         
         make.top.equalTo(imageContainer.snp.bottom)
         make.left.right.equalTo(view)
         make.bottom.equalTo(scrollView)
         }
         */
        
        NSLayoutConstraint.activate([
            articleContainer.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 0.0),
            articleContainer.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0.0),
            articleContainer.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0.0),
            articleContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0.0)
        ])
        
        // Article title
        NSLayoutConstraint.activate([
            articleTitle.leadingAnchor.constraint(equalTo: articleContainer.leadingAnchor, constant: 14),
            articleTitle.trailingAnchor.constraint(equalTo: articleContainer.trailingAnchor, constant: -14),
            articleTitle.topAnchor.constraint(equalTo: articleContainer.topAnchor, constant: 0),
            articleTitle.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        // Article time
        NSLayoutConstraint.activate([
            articleTime.leadingAnchor.constraint(equalTo: articleContainer.leadingAnchor, constant: 14),
            articleTime.trailingAnchor.constraint(equalTo: articleContainer.trailingAnchor, constant: -14),
            articleTime.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 0),
            articleTime.heightAnchor.constraint(equalToConstant: 20.0)
            ])
        
        /*
         infoText.snp.makeConstraints {
         make in
         
         make.edges.equalTo(articleContainer).inset(14)
         }
         */
        
        NSLayoutConstraint.activate([
            articleText.leadingAnchor.constraint(equalTo: articleContainer.leadingAnchor, constant: 7),
            articleText.trailingAnchor.constraint(equalTo: articleContainer.trailingAnchor, constant: -7),
            articleText.topAnchor.constraint(equalTo: articleTime.bottomAnchor, constant: 0),
            articleText.bottomAnchor.constraint(equalTo: articleContainer.bottomAnchor, constant: -14),
            ])
    }
    
    // MARK: Scroll view delegate
    
    private var previousStatusBarHidden = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if previousStatusBarHidden != shouldHideStatusBar {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
    
    //MARK: - Status Bar Appearance
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
        // Causing some sort of infinite loop when scorrling down view.
        //return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        let frame = articleContainer.convert(articleContainer.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
    
    private func updateScrollViewContentSize(){
        if (self.articleText.isLoading == false) {
            
            let evalJs = """
            function calcHeight(){
                var children = document.body.children;
                var loop = 0, height = children[children.length-1].offsetTop + children[children.length-1].clientHeight;
                return height;
            }
            calcHeight();
            """
            
            //self.articleText.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (result, error) in
            self.articleText.evaluateJavaScript(evalJs, completionHandler: { (result, error) in
                if let height = result as? CGFloat {
                    let y = self.imageContainer.frame.maxY + self.articleTime.frame.maxY
                    self.articleText.frame.size.height = height
                    self.scrollView.contentSize.height = (y + height)
                }
            })
        }
    }
    
    //MARK: - WebView content height update
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       self.updateScrollViewContentSize()
    }
    
    //MARK: device rotation handling
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animateAlongsideTransition(in: self.scrollView, animation: nil) { (context) in
            print("rotated")
            self.updateScrollViewContentSize()
        }
    }
}
