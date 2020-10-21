//
//  Utils.swift
//  ReadsSwift
//
//  Created by Ketan on 20/05/20.
//

import Foundation

struct CartItem {
    var sku: String?
    var quantity: Int
    var details: [String: String]?
}

class Utils {
    
    static let shared = Utils()
    
    var cartItems: [CartItem] = []
    
    let products:[[String: String]] = [[
    "sku": "9780140247732",
    "name": "Death of a Salesman",
    "price": "20.00",
    "image_url": "https://images.randomhouse.com/cover/9780140247732",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/drama-american-general/death-of-a-salesman"
    ],
    [
    "sku": "9780140421996",
    "name": "Leaves of Grass",
    "price": "13.00",
    "image_url": "https://images.randomhouse.com/cover/9780140421996",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/poetry-american-general/leaves-of-grass"
    ],
    [
    "sku": "9780140455113",
    "name": "The Republic (Plato)",
    "price": "12.00",
    "image_url": "https://images.randomhouse.com/cover/9780140455113",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/philosophy-history-surveys-ancient-classical/the-republic-plato"
    ],
    [
    "sku": "9780142410370",
    "name": "Matilda",
    "price": "6.99",
    "image_url": "https://images.randomhouse.com/cover/9780142410370",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/juvenile-fiction-action-adventure-general/matilda"
    ],
    [
    "sku": "9780143038412",
    "name": "Eat Pray Love",
    "price": "17.00",
    "image_url": "https://images.randomhouse.com/cover/9780143038412",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/biography-autobiography-personal-memoirs/eat-pray-love"
    ],
    [
    "sku": "9780307278821",
    "name": "Physics of the Impossible",
    "price": "15.95",
    "image_url": "https://images.randomhouse.com/cover/9780307278821",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/science-physics-general/physics-of-the-impossible"
    ],
    [
    "sku": "9780141325293",
    "name": "The Jungle Book",
    "price": "5.99",
    "image_url": "https://images.randomhouse.com/cover/9780141325293",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/juvenile-fiction-classics/the-jungle-book"
    ],
    [
    "sku": "9780142424179",
    "name": "The Fault in Our Stars",
    "price": "12.99",
    "image_url": "https://images.randomhouse.com/cover/9780142424179",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/juvenile-fiction-social-issues-death-dying/the-fault-in-our-stars"
    ],
    [
    "sku": "9780143038580",
    "name": "The Omnivore's Dilemma",
    "price": "18.00",
    "image_url": "https://images.randomhouse.com/cover/9780143038580",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/health-fitness-diet-nutrition-nutrition/the-omnivore-s-dilemma"
    ],
    [
    "sku": "9780142410387",
    "name": "The BFG",
    "price": "18.00",
    "image_url": "https://images.randomhouse.com/cover/9780142410387",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/juvenile-fiction-action-adventure-general/the-bfg"
    ],
    [
    "sku": "9780143034759",
    "name": "Alexander Hamilton",
    "price": "20.00",
    "image_url": "https://images.randomhouse.com/cover/9780143034759",
    "tax": "0",
    "web_url": "https://www.blueshiftreads.com/products/biography-autobiography-political/alexander-hamilton"
    ]]
    
    
}

extension String {
    var boolValue: Bool {
            return (self as NSString).boolValue
    }
}
