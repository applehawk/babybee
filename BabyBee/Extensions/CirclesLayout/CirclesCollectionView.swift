import UIKit

class CirclesCollectionView: UICollectionView {
    var dataSourceData: [CGFloat] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setupCirclesCollectionView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupCirclesCollectionView()
    }
    
    fileprivate func setupCirclesCollectionView() {
        //let cellNib = UINib(nibName: "CircleCell", bundle: nil)
        //register(cellNib, forCellWithReuseIdentifier: "circleCell")
        
        self.dataSource = self
        self.delegate = self
    }
}

extension CirclesCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "circleCell", for: indexPath) as? CircleCell {
            cell.circleLabel.text = String(format: "%.2f", dataSourceData[indexPath.row])
            cell.layer.cornerRadius = cell.frame.size.width / 2.0
            print("cell Dequeue")
            return cell
            //print
        }
        return CircleCell()
    }
}

extension CirclesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: dataSourceData[indexPath.row], height: dataSourceData[indexPath.row])
        print("\(size)")
        return size
    }
}
