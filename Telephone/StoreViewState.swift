//
//  StoreViewState.swift
//  Telephone
//
//  Copyright (c) 2008-2016 Alexey Kuznetsov
//  Copyright (c) 2016 64 Characters
//
//  Telephone is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Telephone is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

// Given State              Event                           Next State               Action
// ---------------------------------------------------------------------------------------------------------------------
// NoProducts               ViewShouldReloadData            Checking                 CheckPurchase
//
// Checking                 DidCheckPurchase                Purchased                ShowThankYou
// Checking                 DidFailCheckingPurchase         Fetching                 FetchProducts
// CheckingAfterFetch       DidCheckPurchase                Purchased                ShowThankYou
// CheckingAfterFetch       DidFailCheckingPurchase         Fetched                  ShowCachedProducts
//
// Fetching                 DidFetchProducts                Fetched                  ShowProducts
// Fetching                 DidFailFetchingProducts         FetchError               ShowProductsFetchError
// Fetched                  ViewDidMakePurchase             Fetched                  PurchaseProduct
// Fetched                  DidStartPurchasing              Purchasing               ShowPurchaseProgress
// Fetched                  ViewDidStartPurchaseRestoration Restoring                RestorePurchases
// FetchError               ViewShouldReloadData            Checking                 CheckPurchase
// FetchError               ViewDidStartProductFetch        Fetching                 FetchProducts
// FetchError               ViewDidStartPurchaseRestoration RestoringAfterFetchError RestorePurchases
//
// Purchasing               DidPurchase                     CheckingAfterFetch       CheckPurchase
// Purchasing               DidFailPurchasingWithError      Fetched                  ShowCachedProductsAndPurchaseError
// Purchasing               DidCancelPurchasing             Fetched                  ShowCachedProducts
// Purchased                ViewShouldReloadData            Checking                 CheckPurchase
//
// Restoring                DidRestorePurchases             CheckingAfterFetch       CheckPurchase
// Restoring                DidFailRestoringPurchases       Fetched                  ShowCachedProductsAndRestoreError
// Restoring                DidCancelRestoringPurchases     Fetched                  ShowCachedProducts
// RestoringAfterFetchError DidRestorePurchases             Checking                 CheckPurchase
// RestoringAfterFetchError DidFailRestoringPurchases       FetchError               ShowCachedFetchErrorAndRestoreError
// RestoringAfterFetchError DidCancelRestoringPurchases     FetchError               ShowCachedFetchError


class StoreViewState {
    func viewShouldReloadData(machine: StoreViewStateMachine) {
        print("\(#function) is not supported for \(self)")
    }

    func didCheckPurchase(machine: StoreViewStateMachine, expiration: Date) {
        print("\(#function) is not supported for \(self)")
    }

    func didFailCheckingPurchase(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }

    func viewDidStartProductFetch(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }

    func didFetchProducts(machine: StoreViewStateMachine, products: [Product])  {
        print("\(#function) is not supported for \(self)")
    }

    func didFailFetchingProducts(machine: StoreViewStateMachine, error: String)  {
        print("\(#function) is not supported for \(self)")
    }

    func viewDidMakePurchase(machine: StoreViewStateMachine, product: PresentationProduct)  {
        print("\(#function) is not supported for \(self)")
    }

    func didStartPurchasingProduct(machine: StoreViewStateMachine, identifier: String) {
        print("\(#function) is not supported for \(self)")
    }

    func didPurchaseProducts(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }

    func didFailPurchasingProducts(machine: StoreViewStateMachine, error: String)  {
        print("\(#function) is not supported for \(self)")
    }

    func didCancelPurchasingProducts(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }

    func viewDidStartPurchaseRestoration(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }

    func didRestorePurchases(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }

    func didFailRestoringPurchases(machine: StoreViewStateMachine, error: String)  {
        print("\(#function) is not supported for \(self)")
    }

    func didCancelRestoringPurchases(machine: StoreViewStateMachine)  {
        print("\(#function) is not supported for \(self)")
    }
}

final class StoreViewStateNoProducts: StoreViewState {
    override func viewShouldReloadData(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateChecking())
        machine.checkPurchase()
    }
}

class StoreViewStateChecking: StoreViewState {
    override func didCheckPurchase(machine: StoreViewStateMachine, expiration: Date) {
        machine.changeState(StoreViewStatePurchased())
        machine.showThankYou(expiration: expiration)
    }

    override func didFailCheckingPurchase(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateFetching())
        machine.fetchProducts()
    }
}

final class StoreViewStateCheckingAfterFetch: StoreViewStateChecking {}

final class StoreViewStateFetching: StoreViewState {
    override func didFetchProducts(machine: StoreViewStateMachine, products: [Product]) {
        machine.changeState(StoreViewStateFetched())
        machine.show(products)
    }

    override func didFailFetchingProducts(machine: StoreViewStateMachine, error: String) {
        machine.changeState(StoreViewStateFetchError())
        machine.showProductsFetchError(error)
    }
}

final class StoreViewStateFetched: StoreViewState {
    override func viewDidMakePurchase(machine: StoreViewStateMachine, product: PresentationProduct) {
        machine.purchaseProduct(withIdentifier: product.identifier)
    }

    override func didStartPurchasingProduct(machine: StoreViewStateMachine, identifier: String) {
        machine.changeState(StoreViewStatePurchasing())
        machine.showPurchaseProgress()
    }

    override func viewDidStartPurchaseRestoration(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateRestoring())
        machine.restorePurchases()
    }
}

final class StoreViewStateFetchError: StoreViewState {
    override func viewShouldReloadData(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateChecking())
        machine.checkPurchase()
    }

    override func viewDidStartProductFetch(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateFetching())
        machine.fetchProducts()
    }

    override func viewDidStartPurchaseRestoration(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateRestoringAfterFetchError())
        machine.restorePurchases()
    }
}

final class StoreViewStatePurchasing: StoreViewState {
    override func didPurchaseProducts(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateCheckingAfterFetch())
        machine.checkPurchase()
    }

    override func didFailPurchasingProducts(machine: StoreViewStateMachine, error: String) {
        machine.changeState(StoreViewStateFetched())
        machine.showCachedProductsAndPurchaseError(error)
    }

    override func didCancelPurchasingProducts(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateFetched())
        machine.showCachedProducts()
    }
}

final class StoreViewStatePurchased: StoreViewState {
    override func viewShouldReloadData(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateChecking())
        machine.checkPurchase()
    }
}

final class StoreViewStateRestoring: StoreViewState {
    override func didRestorePurchases(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateCheckingAfterFetch())
        machine.checkPurchase()
    }

    override func didFailRestoringPurchases(machine: StoreViewStateMachine, error: String) {
        machine.changeState(StoreViewStateFetched())
        machine.showCachedProductsAndRestoreError(error)
    }

    override func didCancelRestoringPurchases(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateFetched())
        machine.showCachedProducts()
    }
}

final class StoreViewStateRestoringAfterFetchError: StoreViewState {
    override func didRestorePurchases(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateChecking())
        machine.checkPurchase()
    }

    override func didFailRestoringPurchases(machine: StoreViewStateMachine, error: String) {
        machine.changeState(StoreViewStateFetchError())
        machine.showCachedFetchErrorAndRestoreError(error)
    }

    override func didCancelRestoringPurchases(machine: StoreViewStateMachine) {
        machine.changeState(StoreViewStateFetchError())
        machine.showCachedFetchError()
    }
}
