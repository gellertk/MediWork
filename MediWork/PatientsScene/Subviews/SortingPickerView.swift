//
//  SortingPickerView.swift
//  MediWork
//
//  Created by Kirill Gellert on 30.05.2023.
//

import UIKit

struct SortField {
    let rowProperty: RowProperty
    let withDirections: Bool
}

enum SortDirection: String {
    case asc
    case desc
}

final class SortingPickerView: UIView {
    
    private let sortingFields: [SortField]
    private var currentSortingField: SortField!
    private var currentDirection: SortDirection?
    
    internal var onApply: ((SortField, SortDirection) -> Void)?
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.alpha = 0
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(self.apply), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var pickerView: UIPickerView = {
        let view: UIPickerView = .init()
        view.alpha = 0
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 12
        return view
    }()

    init(sortingFields: [SortField]) {
        self.sortingFields = sortingFields
        if let firstField = sortingFields.first {
            self.currentSortingField = firstField
            if firstField.withDirections {
                self.currentDirection = .asc
            }
        }
        super.init(frame: .zero)
        self.configureSelf()
        self.configureSubviews()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        self.backgroundColor = .black.withAlphaComponent(0.7)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
    }
    
    private func configureSubviews() {
        self.addSubview(self.pickerView)
        self.addSubview(self.applyButton)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.pickerView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.pickerView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            self.applyButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.applyButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.applyButton.topAnchor.constraint(equalTo: self.pickerView.bottomAnchor, constant: 8),
            self.applyButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.applyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    internal func show() {
        self.pickerView.reloadComponent(0)
        if let selectedFieldIndex = self.sortingFields.firstIndex(where: { $0.rowProperty.label == self.currentSortingField.rowProperty.label }) {
            self.pickerView.selectRow(selectedFieldIndex, inComponent: 0, animated: false)
        } else {
            if let selectedFieldIndex = self.sortingFields.firstIndex(where: { $0.rowProperty.label == self.currentSortingField.rowProperty.label }) {
                self.pickerView.selectRow(selectedFieldIndex, inComponent: 0, animated: false)
            }
        }
        if self.currentDirection == .desc {
            self.pickerView.selectRow(1, inComponent: 1, animated: false)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.alpha = 1
            self.applyButton.alpha = 1
            self.isHidden = false
        }, completion: { _ in
            self.pickerView.isUserInteractionEnabled = true
        })
    }
    
    internal func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.alpha = 0
            self.applyButton.alpha = 0
            self.isHidden = true
        }, completion: { _ in
            self.pickerView.isUserInteractionEnabled = true
        })
    }
    
    @objc
    private func apply() {
        self.hide()
        guard let currentDirection = self.currentDirection else { return }
        self.onApply?(currentSortingField, currentDirection)
    }

}

// MARK: - UIPickerViewDataSource

extension SortingPickerView: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.sortingFields.count
        default:
            return (self.currentSortingField.withDirections) ? 2 : 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {

        var title: String
        if component == 0 {
            title = self.sortingFields[row].rowProperty.label
        } else if self.currentSortingField.withDirections {
            switch row {
            case 0:
                title = "Ascending"
            default:
                title = "Descending"
            }
        } else {
            title = ""
        }

        var container: UIView!
        if let view {
            container = view
        } else {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white
            container = UIView()
            container.backgroundColor = .clear
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor),

                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: component == 0 ? 16 : 0),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: component == 1 ? 16 : 0)
            ])

        }

        if let label = container.subviews.first as? UILabel {
            label.text = title
        }

        return container
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let maxCharsText = ["Ascending", "Descending"]
            .max(by: { $0.count < $1.count })!
        let label = UILabel()
        label.text = maxCharsText
        label.sizeToFit()
        let directionWidth = label.frame.width + 32
        if component == 0 {
            return pickerView.frame.width - directionWidth
        } else {
            return directionWidth
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let shouldReloadDirections = self.currentSortingField.withDirections != self.sortingFields[row].withDirections
            self.currentSortingField = self.sortingFields[row]
            if shouldReloadDirections {
                pickerView.reloadComponent(1)
            }
        } else if self.currentSortingField.withDirections == true {
            switch row {
            case 0:
                self.currentDirection = .asc
            default:
                self.currentDirection = .desc
            }
        } else {
            self.currentDirection = nil
        }
    }
    
}

extension SortingPickerView: UIPickerViewDelegate {
    
    
    
}
