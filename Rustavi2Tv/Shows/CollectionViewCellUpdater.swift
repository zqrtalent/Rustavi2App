//
//  CollectionViewCellUpdater.swift
//  Rustavi2Tv
//
//  Created by Zaqro Butskrikidze on 1/6/19.
//  Copyright © 2019 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewUpdater {
    
    init(view: UICollectionView) {
        _view = view
    }
    
    private var _workItem: DispatchWorkItem?
    private weak var _view: UICollectionView?
    private var _indices: [IndexPath] = []
    
    public func updateCell(at:IndexPath, after:DispatchTime) -> Void{
        if(!Thread.current.isMainThread){
            DispatchQueue.main.async {
                self.updateCell(at: at, after: after)
            }
        }
        else{
            var scheduleJob = _indices.count == 0
            _indices.append(IndexPath(row: at.row, section: at.section))
            
            if(_workItem == nil){
                _workItem = DispatchWorkItem(qos: .userInteractive, block: {
                    print("update ct: \(self._indices.count)")
                    self._view?.reloadItems(at: self._indices)
                    self._indices = []
                })
                scheduleJob = true
            }
            
            // Schedule dispatch work if not scheduled.
            if(scheduleJob){
                DispatchQueue.main.asyncAfter(deadline: after, execute: _workItem!)
            }
        }
    }
    
    private func cleanUp(){
        self._indices = []
        self._workItem = nil
    }
    
    public func cancelUpdate(){
        _workItem?.cancel()
        
        cleanUp()
    }
}
