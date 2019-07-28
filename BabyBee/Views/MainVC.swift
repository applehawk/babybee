import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var collectionViewCircles: CirclesCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewCircles.dataSourceData = [120, 160, 80, 120, 80, 140, 100, 200]
        collectionViewCircles.reloadData()
    }
}
