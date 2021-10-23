//
//  HomeVC.swift
//  Wish Tracker

// Author name : Vivek Chodvadiya
// This View controller is used for Home page
// This view contains auto scrollable pager for display images
// redirect from this page to new wish, my wishes, my full filed wishes page and setting page

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var btnSetting: UIButton!
    
    @IBOutlet weak var btnNewWish: UIButton!
    @IBOutlet weak var btnFullFilledWishes: UIButton!
    @IBOutlet weak var btnMyWishes: UIButton!
    
    @IBOutlet weak var clvIntroduction: UICollectionView!
    @IBOutlet weak var pager: UIPageControl!
    
    // MARK: - Properties
    let arrIntroduction = [["title": "I thought it was every nurse's dream to marry a doctor.", "image": "img1"],
                           ["title": "Since her dream, she'd heard him even when she was awake.", "image": "img2"],
                           ["title": "Now a billion or more can achieve that dream, and I foresee a time not far off when everyone on the planet can.", "image": "img3"],
                           ["title": "This comforting dream and hope were given her by God's folk-- the half-witted and other pilgrims who visited her without the prince's knowledge.", "image": "img4"]]
    
    
    // MARK: - VC Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
//  set UICollectionView and timer for auto scroll pager
    func initView(){
        clvIntroduction.register(UINib(nibName: "IntroductionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IntroductionCollectionViewCell")
        clvIntroduction.delegate = self
        clvIntroduction.dataSource = self
        
        clvIntroduction.reloadData()
        
        let timer =  Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
//  auto scrollable pager
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = clvIntroduction {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < arrIntroduction.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    pager.currentPage = (indexPath?.row)!
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                } else {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    pager.currentPage = (indexPath?.row)!
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }
    }
    
    // MARK: - Action
    
//  redirect to my new wishe page on click of new wish button
    @IBAction func onBtnNewWish(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewWishVC") as! NewWishVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  redirect to my full filled wishes page on click og my full filled wishes button
    @IBAction func onBtnFullFilledWishes(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyFullFilledWishesVC") as! MyFullFilledWishesVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  redirect to my wishes list page on click of my wishes button
    @IBAction func onBtnMyWish(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyWishesVC") as! MyWishesVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
//  redirect to setting page on click of setting icon
    @IBAction private func onBtnSetting(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrIntroduction.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroductionCollectionViewCell", for: indexPath as IndexPath) as! IntroductionCollectionViewCell
        
        let obj = arrIntroduction[indexPath.row]
        cell.lblInfo.text = obj["title"] ?? ""
        cell.imgIntroduction.image = UIImage(named: obj["image"] ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = UIScreen.main.bounds.height / 0.45
        
        return CGSize(width: width, height: width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = clvIntroduction.contentOffset
        visibleRect.size = clvIntroduction.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = clvIntroduction.indexPathForItem(at: visiblePoint) else { return }

        pager.currentPage = indexPath.row
    }
}
