//
//  UnidirectionalList.swift
//  LinkedListBasics
//
//  Created by admin on 18/12/2017.
//  Copyright © 2017 Andrei Ermoshin. All rights reserved.
//

// FIFO

import Foundation

class UnidirectionalListNode<T> {
    let value: T
    var next: UnidirectionalListNode?
    init(v: T) {
        value = v
    }
}

// Typical linked list could be used to implement
// stack or queue

class UnidirectionalLinkedList<T: Comparable> {
    // use optionals because list could be empty
    private var head: UnidirectionalListNode<T>?
    private var last: UnidirectionalListNode<T>?
    
    init(v: T) {
        head = UnidirectionalListNode<T>(v: v)
        last = head
    }
    
    init(h: UnidirectionalListNode<T>) {
        head = h
        // TODO: need to calculate last by traversing head link
    }
    
    func push(v: T) {
        // Places an object on the top of the stack.
        let freshNode = UnidirectionalListNode(v: v)
        freshNode.next = head
        head = freshNode
        if last == nil {
            last = head
        }
    }
    
    func count() -> UInt {
        var index = head
        var count: UInt = 0
        while let current = index {
            // already +1
            if let secondNode = current.next {
                // now it's +2
                index = secondNode
                count += 2
            }
            else {
                // end of the list
                count += 1
                break
            }
        }
        return count
    }
    
    func pop() -> T? {
        // Removes an object from the top of the stack and produces that object.
        let result = head
        if head === last {
            last = nil
            head = nil
        }
        else {
            head = head?.next
        }
        
        return result?.value
    }
    
    func append(v: T) {
        // Not for FIFO
        // just to add at the end
        // so, it's not typical task for common linked list
        
        let freshNode = UnidirectionalListNode(v: v)
        last?.next = freshNode
        last = freshNode
    }
    
    func containsLoop() -> Bool {
        // https://www.geeksforgeeks.org/detect-loop-in-a-linked-list/
        // lets assume that last node is not known by our implementation
        // so, need to find it, usually it could be found by checking if next node
        // equals nil or not, but in case of corrupted linked list with a loop
        // all next nodes will be not nil's
        
        guard head != nil else {
            // empty list defenetly without loop
            return false
        }
        
        var nodeIx = head
        while let xNode = nodeIx {
            if let xNext = xNode.next {
                // node for next cycle will not be nil for sure
                var nodeIy: UnidirectionalListNode = head!
                // now need to compare with previus nodes
                repeat {
                    if xNext === nodeIy {
                        // found a loop
                        return true
                    }
                    else {
                        if nodeIy === xNode {
                            // the case when need to check
                            // just one node that it doesn't points
                            // on itself
                            break
                        }
                        nodeIy = nodeIy.next!
                    }
                } while nodeIy !== xNode
                nodeIx = nodeIx?.next
            }
            else {
                // we found next equals nil, so it's last node
                // no loop exist
                return false
            }
        }
        // as soon as checked node is nil
        // it means that we found end of linked list and
        // it is without loop
        return false
    }
    
    class func merge(first: UnidirectionalLinkedList<T>, second: UnidirectionalLinkedList<T>) -> UnidirectionalLinkedList<T>? {
        
        
        switch (first.head, second.head) {
        case (nil, nil):
            return nil
        case (nil, _?):
            return second
        case (_?, nil):
            return first
        case let (firstHead?, secondHead?):
            
            var resultHead: UnidirectionalListNode<T> // dummy default value
            var f: UnidirectionalListNode? = firstHead
            var s: UnidirectionalListNode? = secondHead
            
            // Need to init result head before cycle
            if firstHead.value < secondHead.value {
                resultHead = firstHead
                f = firstHead.next
            }
            else if firstHead.value > secondHead.value {
                resultHead = secondHead
                s = secondHead.next
            }
            else {
                // equality
                resultHead = firstHead
                f = firstHead.next
                s = secondHead.next
            }
            
            var indexNode = resultHead
            let resultList = UnidirectionalLinkedList(h: resultHead)
            
            while true {
                switch (f, s) {
                case (nil, nil):
                    // both lists were with same length
                    return resultList
                case let (ff?, nil):
                    indexNode.next = ff
                    return resultList
                case let (nil, ss?):
                    indexNode.next = ss
                    return resultList
                case let (ff?, ss?):
                    if ff.value < ss.value {
                        indexNode.next = ff
                        f = ff.next
                    }
                    else if ff.value > ss.value {
                        indexNode.next = ss
                        s = ss.next
                    }
                    else {
                        indexNode.next = ff
                        f = ff.next
                        s = ss.next
                    }
                    indexNode = indexNode.next!
                }
            }
        }
        
    }
    
    func removeDuplicates() {
        // This works only for sorted list
        var index = head
        while index != nil {
            if let newNext = index!.next {
                if index!.value == newNext.value {
                    // need to find fixed next node for current index
                    var secondIndex: UnidirectionalListNode<T>? = newNext
                    var fixedNext: UnidirectionalListNode<T>?
                    while let second = secondIndex {
                        if let secondNext = second.next {
                            if second.value != secondNext.value {
                                fixedNext = secondNext
                                break
                            }
                            else {
                                secondIndex = secondIndex?.next
                                // next iteration on 2nd cycle
                            }
                        }
                        else {
                            // it is when you found duplicate
                            // but after it nil is following
                            // so it is end
                            fixedNext = nil
                            break
                        }
                    }
                    index?.next = fixedNext
                    index = fixedNext
                    // next iteration on 1st cycle
                }
                else {
                    // continue
                    index = newNext
                }
            }
            else {
                break
            }
        }
    }
}

extension UnidirectionalLinkedList: CustomStringConvertible {
    var description: String {
        var result = "Description: \n"
        guard let head = head else {
            return result
        }
        var index = head
        result.append("\(index.value), ")
        while index.next != nil {
            index = index.next!
            result.append("\(index.value), ")
        }
        return result
    }
}

// Just for tests and tasks
extension UnidirectionalLinkedList {
    func lastNode() -> UnidirectionalListNode<T>? {
        return last
    }
    
    func node(at index: UInt) -> UnidirectionalListNode<T>? {
        var currentIx = 0
        var nodeIx = head
        while nodeIx != nil && currentIx < index {
            nodeIx = nodeIx?.next
            currentIx += 1
        }
        return nodeIx
    }
}

