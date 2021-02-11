//
//  FullScreenViewController.swift
//  testAppBeta
//
//  Created by Дмитрий Подольский on 11.02.2020.
//

import UIKit

class FullScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var dateLoad: UILabel!
    
    let photoGallerys = ProfileViewController()

    var titlesFS:[String?] = []
    var pictureFS:[String?] = []
    var birthdayFS:[String?] = []
    let countCells = 1
    let identifire = "FullScreenCell"
    var indexPath:IndexPath = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.register(UINib(nibName: "FullScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifire)
        
        collectionView.performBatchUpdates(nil) { ( result ) in
            self.collectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
            titlesFS = photoGallerys.titles
            pictureFS = photoGallerys.picture
            birthdayFS = photoGallerys.birthday
    }
}

extension FullScreenViewController:UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath) as! FullScreenCollectionViewCell
    
        if pictureFS.count != 0 {
            let picFS = pictureFS[self.indexPath.item]
            fullname.text = "Name: " +  titlesFS[self.indexPath.item]!
            birthday.text = "Birthday: " + birthdayFS[self.indexPath.item]!
                cell.photoView.image = UIImage(data: NSData(contentsOf: NSURL(string: picFS! )! as URL)! as Data)
            let formatter = DateFormatter()
            let date = Date()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateGlobal = formatter.string(from: date)
            dateLoad.text = "Load time: " + dateGlobal
        } else {
            cell.photoView.image = UIImage(named: "wifibitch")!
            fullname.text = "Упс"
            birthday.text = "Нет связи с интернетом"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let frameCV = collectionView.frame
        let widthCell = frameCV.width / CGFloat(countCells)
        let heightCell = widthCell
        
        return CGSize(width: widthCell, height: heightCell)
    }
}


