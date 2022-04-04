//
//  ListViewController.swift
//  SCB
//
//  Created by Mac on 02/04/22.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    let cellListIdentifier = "ListCollectionViewCell"
    var searchListArr = [ListResponseSearch]()

    var isLastPage = true
    var nextPage = 1
    var searchText = "IronMan"

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        loadModel()
    }

    // MARK: - setUpUI

    func setUpUI() {

        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchTextField.delegate = self

        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: cellListIdentifier, bundle: nil), forCellWithReuseIdentifier: cellListIdentifier)
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    func loadModel() {
        getMoviesListApiRequest("IronMan")
    }

//MARK: - ApiRequest

    func getMoviesListApiRequest(_ movieName:String) {

        if !HELPER.isConnectedToNetwork() {

            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: SCB.appName, aStrMessage: "Please Check your network connection")
            return
        }

        CustomLoader.loading(view, enable: true)

        let params = ["apikey":"b9bd48a6",
                      "s":movieName,
                      "page":nextPage] as [String : Any]
        
        HTTPMANAGER.callApi(viewController: self, method: .get, url: SCB.baseURL , parameters: params, header: [:], decodableType: ListResponse.self) {
            (decodable) in
            CustomLoader.dismiss(self.view)

            guard let aModel = decodable as? ListResponse else { return }

            switch aModel.response {
            case "True":
                self.updateMovieList(aModel,isTrue: true)

            default:
                self.updateMovieList(aModel,isTrue: false)

            }
        }
    }
    //MARK: - updateMovieList

    func updateMovieList(_ details: ListResponse, isTrue:Bool) {

        if isTrue {
            self.noDataLabel.isHidden = true
            self.myCollectionView.isHidden = false
            guard let List = details.search else {  return }

            let totalResult = details.totalResults ?? ""
            let count = Int(totalResult)!/10
            self.isLastPage = count == self.nextPage ? false : true

            self.nextPage = self.nextPage + 1

            for items in List {
                self.searchListArr.append(items)
            }

            self.searchBar.resignFirstResponder()
            self.myCollectionView.reloadData()
        } else {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: SCB.appName, aStrMessage: details.error ?? "")

            switch self.searchListArr.count {
            case 0:
                self.noDataLabel.isHidden = false
                self.myCollectionView.isHidden = true
                self.searchListArr = []
                self.myCollectionView.reloadData()

            default:
                break
            }
        }
    }
    //MARK: - seachClearValue
    func seachClearValue() {
        searchListArr = []
        myCollectionView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchText = ""
        nextPage = 1
        view.endEditing(true)

    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

extension ListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return searchListArr.count + (isLastPage ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row >= searchListArr.count {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell" , for: indexPath)
            return aCell

        } else {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellListIdentifier, for: indexPath) as! ListCollectionViewCell
            aCell.updateDetails(details: searchListArr[indexPath.row])
            return aCell

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width:(myCollectionView.bounds.width - 30) / 2  , height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let aViewController = DetailViewController()
        aViewController.movieIdStr = searchListArr[indexPath.row].imdbID ?? ""
        self.navigationController?.pushViewController(aViewController, animated: true)
    }

    // MARK: - Scroll view delegate and data source
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)
        let ret = contentOffsetMaxY > contentHeight
        if ret {

            if isLastPage {
                isLastPage = false
                self.getMoviesListApiRequest(searchText)
            }
        }else{
        }
    }
}

//MARK: - ApiRequest
extension ListViewController: UISearchBarDelegate, UITextFieldDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text ?? ""
        searchBar.showsCancelButton = true
        if searchText.count >= 3 {
            searchListArr = []
            getMoviesListApiRequest(searchText)
        } else {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: SCB.appName, aStrMessage: "Minimum search letters should be 3 and above")
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        seachClearValue()
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        seachClearValue()
        searchBar.text = ""
    }
}
