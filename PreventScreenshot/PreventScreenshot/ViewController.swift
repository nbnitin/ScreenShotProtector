//
//  ViewController.swift
//  PreventScreenshot
//
//  Created by Nitin Bhatia on 25/4/23.
//

//to trigger screenshot or app switcher in simulator, open simulator in menu under devices there are respective options


import UIKit

class ViewController: UIViewController {
   
    //outlets
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var lblAllowPermissionText: UILabel!
    @IBOutlet weak var btnSwtichAllowPermission: UISwitch!
    
    
    //variables
    let images: [UIImage] = [UIImage(named: "selfie1")!,
                             UIImage(named: "selfie2")!,
                             UIImage(named: "selfie3")!,
                             UIImage(named: "selfie4")!]
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    lazy var hello : ScreenshotPreventingView = ScreenshotPreventingView(contentView: collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        view.addSubview(hello)
        hello.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.bringSubviewToFront(overlayView)
        view.bringSubviewToFront(btnSwtichAllowPermission)
        view.bringSubviewToFront(lblAllowPermissionText)
    }
    
    @IBAction func btnSwitchAllowPermission(_ sender: Any) {
        hello.preventScreenCapture = btnSwtichAllowPermission.isOn
    }
    
}

extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                             heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
    }
    private func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with image
            cell.configure(image: self.images[indexPath.row % 4])
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<100))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

