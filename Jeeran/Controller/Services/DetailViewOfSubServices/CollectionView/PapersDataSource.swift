//
//  PapersDataSource.swift
//  Wallpapers
//
//  Created by Mic Pringle on 07/01/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class PapersDataSource {
    
    private var papers: [Paper] = []
    private var immutablePapers: [Paper] = []
    private var sections: [String] = []
    static var subServicesCategory = [ResponseServiceList]()
    var count: Int {
        return papers.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    // MARK: Public
    
    init() {
        papers = loadPapersFromDisk()
        immutablePapers = papers
    }
    
    func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        var indexes: [Int] = []
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newPapers: [Paper] = []
        for (index, paper) in papers.enumerate() {
            if !indexes.contains(index) {
                newPapers.append(paper)
            }
        }
        papers = newPapers
    }
    
    func indexPathForNewRandomPaper() -> NSIndexPath {
        let index = Int(arc4random_uniform(UInt32(immutablePapers.count)))
        let paperToCopy = immutablePapers[index]
        let newPaper = Paper(copying: paperToCopy)
        papers.append(newPaper)
        papers.sortInPlace { $0.index < $1.index }
        return indexPathForPaper(newPaper)
    }
    
    func indexPathForPaper(paper: Paper) -> NSIndexPath {
        let section = sections.indexOf(paper.section)!
        var item = 0
        for (index, currentPaper) in papersForSection(section).enumerate() {
            if currentPaper === paper {
                item = index
                break
            }
        }
        return NSIndexPath(forItem: item, inSection: section)
    }
    
    func movePaperAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        if indexPath == newIndexPath {
            return
        }
        let index = absoluteIndexForIndexPath(indexPath)
        let paper = papers[index]
        paper.section = sections[newIndexPath.section]
        let newIndex = absoluteIndexForIndexPath(newIndexPath)
        papers.removeAtIndex(index)
        papers.insert(paper, atIndex: newIndex)
    }
    
    func numberOfPapersInSection(index: Int) -> Int {
        let papers = papersForSection(index)
        return papers.count
    }
    
    func paperForItemAtIndexPath(indexPath: NSIndexPath) -> Paper? {
        if indexPath.section > 0 {
            let papers = papersForSection(indexPath.section)
            return papers[indexPath.item]
        } else {
            return papers[indexPath.item]
        }
    }
    
    func titleForSectionAtIndexPath(indexPath: NSIndexPath) -> String? {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        return nil
    }
    
    // MARK: Private
    
    private func absoluteIndexForIndexPath(indexPath: NSIndexPath) -> Int {
        var index = 0
        for i in 0..<indexPath.section {
            index += numberOfPapersInSection(i)
        }
        index += indexPath.item
        return index
    }
    
    private func loadPapersFromDisk() -> [Paper] {
        sections.removeAll(keepCapacity: false)
        var papers: [Paper] = []
        print("=====================",PapersDataSource.subServicesCategory.count)
        if PapersDataSource.subServicesCategory.count == 0
        {  let paper = Paper(caption: "ddd", section: "1", index: 1,rate: 3,name: "Sun Moll")
            WebserviceManager.getImage("http://static1.yellow-pages.ph/business_photos/438185/sun_mall_thumbnail.png" , result: { (image, code) in
                paper.imageName = image
            })
            papers.append(paper)
        }
        else
        {
            for subService in PapersDataSource.subServicesCategory {
                let paper = Paper(caption: "ddd", section: "1", index: 1,rate: 4 ,name: subService.title!)
                WebserviceManager.getImage(subService.logo! , result: { (image, code) in
                    paper.imageName = image
                })
                papers.append(paper)
            }
        }
        return papers
    }
    
    private func papersForSection(index: Int) -> [Paper] {
        let section = sections[index]
        let papersInSection = papers.filter { (paper: Paper) -> Bool in
            return paper.section == section
        }
        return papersInSection
    }
    
}
