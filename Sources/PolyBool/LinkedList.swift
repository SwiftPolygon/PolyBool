//
//  LinkedList.swift
//  LinkedList
//
//  Created by Nail Sharipov on 02.11.2022.
//

struct LinkedList<T> {
    
    struct Item<T> {
        
        fileprivate (set) var prev: Int
        fileprivate (set) var index: Int
        fileprivate (set) var next: Int
        fileprivate (set) var isNode: Bool
        
        @inlinable
        var exist: Bool { index != -1 }
        
        var value: T
        
        fileprivate init(value: T, prev: Int, index: Int, next: Int, isNode: Bool) {
            self.prev = prev
            self.index = index
            self.next = next
            self.value = value
            self.isNode = isNode
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.index == rhs.index
        }
    }

    @inlinable
    var isEmpty: Bool { first == -1 }
    
    @inlinable
    var head: Item<T> { items[first] }

    @inlinable
    func exist(index: Int) -> Bool {
        guard index < items.count && index >= 0 else { return false }
        return items[index].exist
    }
    
    private (set) var count: Int
    private (set) var first: Int
    private (set) var last: Int
    private let empty: T
    private (set) var items: [Item<T>]
    private var free: [Int]

    @inlinable
    func item(index: Int) -> Item<T> {
        guard index < items.count && index >= 0 else { return Item(value: empty, prev: -1, index: -1, next: -1, isNode: false) }
        return items[index]
    }
    
    @inlinable
    var values: [T] {
        var result = [T]()
        result.reserveCapacity(count)
        var index = first
        while index != -1 {
            let item = items[index]
            result.append(item.value)
            index = item.next
        }
        return result
    }
    
    @inlinable
    var inverse: [T] {
        var result = [T]()
        result.reserveCapacity(count)
        var index = last
        while index != -1 {
            let item = items[index]
            result.append(item.value)
            index = item.prev
        }
        return result
    }
    
    @inlinable
    init(empty: T, capacity: Int = 16) {
        self.empty = empty
        count = 0
        first = -1
        last = -1
        items = [Item]()
        items.reserveCapacity(capacity)
        free = [Int]()
        free.reserveCapacity(capacity)
    }
    
    @inlinable
    init(values: [T], empty: T) {
        self.empty = empty
        count = values.count
        items = [Item](repeating: Item(value: empty, prev: -1, index: -1, next: -1, isNode: false), count: count)
        for i in 0..<values.count {
            items[i] = Item(
                value: values[i],
                prev: i - 1,
                index: i,
                next: i + 1,
                isNode: true
            )
        }
        items[count - 1].next = -1
        first = 0
        last = count - 1
        free = [Int]()
        free.reserveCapacity(count)
    }

    @inlinable
    subscript(index: Int) -> Item<T> {
        get {
            items[index]
        }
        set {
            items[index] = newValue
        }
    }
    
    @inlinable
    mutating func create(value: T) -> Item<T> {
        let item: Item<T>
        
        if free.isEmpty {
            let i = items.count
            item = Item(value: value, prev: -1, index: i, next: -1, isNode: false)
            items.append(item)
        } else {
            let i = free.removeLast()
            item = Item(value: value, prev: -1, index: i, next: -1, isNode: false)
            items[i] = item
        }
        
        return item
    }

    @inlinable
    mutating func add(item: Item<T>) {
        if first == -1 {
            first = item.index
        }

        items[item.index] = .init(
            value: item.value,
            prev: last,
            index: item.index,
            next: item.next,
            isNode: true
        )

        
        if last != -1 {
            items[last].next = item.index
        }

        last = item.index
        
        count += 1
    }
    
    
    @inlinable
    mutating func add(value: T) -> Int {
        let item = self.create(value: value)
        self.add(item: item)
        return item.index
    }

    @inlinable
    mutating func insertBefore(index: Int, item: Item<T>) {
        var after = items[index]
        
        var item = item
        
        item.prev = after.prev
        item.next = index
        item.isNode = true
        items[item.index] = item
        
        if item.prev == -1 {
            first = item.index
        } else {
            items[item.prev].next = item.index
        }
        
        after.prev = item.index
        items[index] = after
        
        count += 1
    }

    @inlinable
    mutating func insertBefore(index: Int, value: T) -> Int {
        let item = self.create(value: value)
        self.insertBefore(index: index, item: item)
        return item.index
    }
    
    @inlinable
    mutating func insertBetween(a0: Int, a2: Int, value: T) -> Int {
        var item = create(value: value)
        
        item.prev = a0
        item.next = a2
        item.isNode = true
        
        if a0 == -1 {
            first = item.index
        } else {
            items[a0].next = item.index
        }

        if a2 == -1 {
            last = item.index
        } else {
            items[a2].prev = item.index
        }
        
        items[item.index] = item
        
        count += 1
        
        return item.index
    }
    
    @inlinable
    mutating func remove(item: Item<T>) {
        self.remove(index: item.index)
    }
    
    @inlinable
    mutating func remove(index: Int) {
        let item = items[index]
        assert(item.index == index)
        items[index] = Item(value: empty, prev: -1, index: -1, next: -1, isNode: false)
       
        if item.prev != -1 {
            items[item.prev].next = item.next
        } else {
            first = item.next
        }
        
        if item.next != -1 {
            items[item.next].prev = item.prev
        } else {
            last = item.prev
        }
        
        free.append(index)
     
        if item.isNode {
            count -= 1
        }
    }
    
    @inlinable
    mutating func unlink(index: Int) {
        let item = items[index]
        assert(item.index == index)
        items[index] = Item(
            value: item.value,
            prev: -1,
            index: index,
            next: -1,
            isNode: false
        )
       
        if item.prev != -1 {
            items[item.prev].next = item.next
        } else {
            first = item.next
        }
        
        if item.next != -1 {
            items[item.next].prev = item.prev
        } else {
            last = item.prev
        }
    }
    
}
