//
//  AwardCollectionViewDatasource.swift
//  r-Swift

import UIKit

// MARK: - UICollectionViewDataSource

extension PostTableViewCell: UICollectionViewDataSource {
    // MARK: numberOfItemsInSection

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awards?.count ?? Constants.CGFloatValue.k0.intValue
    }

    // MARK: cellForItemAt

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AwardCollectionViewCell.identifier, for: indexPath) as? AwardCollectionViewCell, let award = awards?[indexPath.item] else { return UICollectionViewCell() }
        cell.configure(award)
        return cell
    }
}
