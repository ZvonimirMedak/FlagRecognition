//
//  HomeViewController.swift
//  FlagRecognition
//
//  Created by Zvonimir Medak on 04.02.2021..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreML
import Vision
import ImageIO


class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let selectedImage: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let imagePickerButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.add, for: .normal)
        return button
    }()
    
    private let classificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let configuration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: FlagRecognizerModel_2(configuration: MLModelConfiguration()).model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        setupUI()
        setupAction()
    }
}

private extension HomeViewController {
    
    func setupUI() {
        view.addSubviews(selectedImage, imagePickerButton, classificationLabel)
        view.backgroundColor = .darkGray
        setupConstraints()
    }
    
    func setupConstraints() {
        selectedImage.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.width)
        }
        
        imagePickerButton.snp.makeConstraints { (maker) in
            maker.bottom.leading.equalToSuperview().inset(25)
            maker.height.width.equalTo(50)
        }
        
        classificationLabel.snp.makeConstraints { (maker) in
            maker.trailing.bottom.equalToSuperview().inset(25)
        }
    }
}

private extension HomeViewController {
    
    func setupAction() {
        imagePickerButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.openImagePicker()
            }).disposed(by: disposeBag)
    }
    
    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("error")
            return
        }
        selectedImage.image = image
        updateClassifications(for: image)
    }
}

private extension HomeViewController {
    
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) ?? .up
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                var highestConfidenceClassification = classifications[0]
                for classification in classifications {
                    if highestConfidenceClassification.confidence < classification.confidence {
                        highestConfidenceClassification = classification
                    }
                }
                self.classificationLabel.text = highestConfidenceClassification.identifier + "\n\(highestConfidenceClassification.confidence)"
            }
        }
    }
}
