//
//  DetailViewController.swift
//  SCB
//
//  Created by Mac on 03/04/22.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var myTableView: UITableView!

    let cellIdentifier = "HeaderImageTableViewCell"

    var movieIdStr = String()

    var movieDetails : MovieDetailsResponse?
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadModel()
    }

    func setUpView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

    }

    func loadModel() {
        getMoviesDetailsApiRequest()
    }
    //MARK: - ApiRequest

    func getMoviesDetailsApiRequest() {

        if !HELPER.isConnectedToNetwork() {

            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: SCB.appName, aStrMessage: "Please Check your network connection")
            return
        }

        CustomLoader.loading(view, enable: true)

        let params = ["apikey":"b9bd48a6",
                      "i":movieIdStr]

        HTTPMANAGER.callApi(viewController: self, method: .get, url: SCB.baseURL , parameters: params, header: [:], decodableType: MovieDetailsResponse.self) {
            (decodable) in
            CustomLoader.dismiss(self.view)

            guard let aModel = decodable as? MovieDetailsResponse else { return }

            switch aModel.response {
            case "True":

                self.movieDetails = aModel
                self.myTableView.reloadData()

            default:
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: SCB.appName, aStrMessage: aModel.error ?? "")
            }
        }
    }
}
//MARK: - UITableViewDataSource, UITableViewDelegate

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HeaderImageTableViewCell
            aCell.updateDetails(movieDetails)
            return aCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
