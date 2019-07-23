import UIKit

let kMinSpaceBetweenCircles: CGFloat = 10.0
let kPositionIncrement: CGFloat = 5.0

let kMaxPredecessorNum = 4

class CirclesLayout: UICollectionViewLayout {
    
    typealias LayoutAttributes = [IndexPath : UICollectionViewLayoutAttributes]
    // "Cached" layout information
    var layoutInfo: LayoutAttributes = [:]
    var contentHeight: CGFloat = 0.0
    // Helpers
    var viewInsets: UIEdgeInsets!
    var initialX: CGFloat = 0.0
    var initialY: CGFloat = 0.0
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Initial settings.
    func setup() {
        viewInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // top, left, bottom, right
    }
    
    // MARK: - Required functions for custom layouts
    override var collectionViewContentSize: CGSize {
        
        guard let collectionView = collectionView else {
            assertionFailure("CollectionView not settable")
            return CGSize()
        }
        
        return CGSize(width: collectionView.bounds.size.width, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInfo[indexPath] as? UICollectionViewLayoutAttributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes: [UICollectionViewLayoutAttributes] = []
        
        for (_, attributes) in layoutInfo {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }

    // Caching layout attributes.
    override func prepare() {
        var newLayoutInfo: LayoutAttributes = [:]
        contentHeight = viewInsets.top
        initialX = viewInsets.left
        initialY = viewInsets.top
        
        guard let collectionView = collectionView else {
            assertionFailure("CollectionView not settable")
            return super.prepare()
        }

        let itemCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: 0)
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            itemAttributes.frame = frameForCircle(at: indexPath, layoutInfo: newLayoutInfo)
            newLayoutInfo[indexPath] = itemAttributes
            
            contentHeight = max(contentHeight, (itemAttributes.frame.origin.y + itemAttributes.frame.size.height))
        }
        
        contentHeight += viewInsets.bottom
        layoutInfo = newLayoutInfo
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        guard let collectionView = collectionView else {
            assertionFailure("CollectionView not settable")
            return CGSize(width: 0.0, height: 0.0)
        }
        
        if let flowLayout = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            
            return flowLayout.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
        }
        return CGSize(width: 0.0, height: 0.0)
    }

    func frameForCircle(at indexPath: IndexPath, layoutInfo newLayoutInfo: LayoutAttributes) -> CGRect {
        var originX = initialX
        var originY = initialY
        let width = sizeForItem(at: indexPath).width
        var circle: CGRect
        
        circle = CGRect(x: CGFloat(originX), y: CGFloat(originY), width: CGFloat(width), height: CGFloat(width))
        while !distanceCondition(forItem: circle, at: indexPath, inLayout: newLayoutInfo) {
            
            originX += kPositionIncrement
            
            if CGFloat(originX + width) + viewInsets.right > (collectionView?.bounds.size.width ?? 0.0) {
                originX = viewInsets.left
                originY += kPositionIncrement
            }
            circle = CGRect(x: CGFloat(originX), y: CGFloat(originY), width: CGFloat(width), height: CGFloat(width))
        }
        
        // Set initial X i Y.
        initialX = originX + (width / 2)
        initialY = originY
        
        return CGRect(x: CGFloat(originX), y: CGFloat(originY), width: CGFloat(width), height: CGFloat(width))
    }
    
    func distanceCondition(forItem circle: CGRect, at indexPath: IndexPath, inLayout newLayoutInfo: LayoutAttributes) -> Bool {
        var condition = true
        
        var numPredecessors = indexPath.row
        if indexPath.row >= kMaxPredecessorNum {
            numPredecessors = kMaxPredecessorNum
        }
        
        for i in 1...numPredecessors {
            let ip = IndexPath(item: (max(indexPath.row - i, 0)), section: 0)
            
            guard let attr = newLayoutInfo[ip] else {
                assertionFailure("We don't have attribute at \(ip)")
                return false
            }
            
            condition = condition && distanceBetween(circle, and: attr.frame, isLargerThan: kMinSpaceBetweenCircles)
        }
        
        return condition
    }
    
    func distanceBetween(_ circle1: CGRect, and circle2: CGRect, isLargerThan delta: CGFloat) -> Bool {
        let r1 = circle1.size.width / 2
        let cx1 = circle1.origin.x + CGFloat(r1)
        let cy1 = circle1.origin.y + CGFloat(r1)
        
        let r2 = circle2.size.width / 2
        let cx2 = circle2.origin.x + CGFloat(r2)
        let cy2 = circle2.origin.y + CGFloat(r2)
        
        let d = sqrt((pow(cx1 - cx2, 2) + pow(cy1 - cy2, 2)))
        
        return d >= r1 + r2 + delta
    }

}
