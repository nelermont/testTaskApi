//
//  ProfileViewController.swift
//  testAppBeta
//
//  Created by Дмитрий Подольский on 11.02.2020.
//

import UIKit

class ProfileViewController: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView!

    let identifier = "PhotoCollectionViewCell"
    
    let countCells = 3
    let offset:CGFloat = 2.0
    
    let urlString = "https://www.breakingbadapi.com/api/characters"
    var titles = [String?]()
    var picture = [String?]()
    var birthday = [String?]()
    
 func parsJSON() {
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with:url!) { [self] (data, response, error) in
        if error != nil {
            print(error!.localizedDescription)
        } else {
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [[String : Any]]
                for item in parsedData
                {
                    let id = item["name"] as! String
                    let photo = item["img"] as! String
                    let bd = item["birthday"] as! String
                    titles.append(id)
                    picture.append(photo)
                    birthday.append(bd)
                }
                DispatchQueue.main.async{ [self] in
                           collectionView.reloadData()}

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        parsJSON()
    }
}

extension ProfileViewController:UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if picture.count != 0 {
            return picture.count
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        if picture.count == 0 {
            cell.photoView.image = UIImage(named: "wifibitch")!
            cell.name.text = "Загрузка"
        } else {
            let pic = picture[indexPath.item]
            let title = titles[indexPath.item]
            cell.name.text = title
            cell.photoView.image = UIImage(data: NSData(contentsOf: NSURL(string: pic! )! as URL)! as Data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let frameCV = collectionView.frame
        let spacing =
            CGFloat((countCells + 1)) *
            offset / CGFloat(countCells)
        let widthCell = frameCV.width / CGFloat(countCells)
        let heightCell = widthCell
        
        return CGSize(width: widthCell - spacing, height: heightCell - (offset*2))
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FullScreenViewController") as! FullScreenViewController
    
        vc.pictureFS = picture
        vc.titlesFS = titles
        vc.birthdayFS = birthday
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
