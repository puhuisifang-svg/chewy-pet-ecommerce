#!/usr/bin/env python3
"""
Chewy.com 商品数据爬虫
注意：Chewy 有 Cloudflare 保护，本脚本用于参考，实际可能需要配合代理/无头浏览器
"""
import requests
from bs4 import BeautifulSoup
import time
import random
import json
import re
import sys

HEADERS_LIST = [
    {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
    },
    {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    }
]

CATEGORIES = {
    "dog": {"url": "https://www.chewy.com/b/food-332", "count": 30},
    "cat": {"url": "https://www.chewy.com/b/food-332", "count": 30},
    "fish": {"url": "https://www.chewy.com/b/fish-329", "count": 15},
    "bird": {"url": "https://www.chewy.com/b/bird-330", "count": 15},
    "small-pet": {"url": "https://www.chewy.com/b/small-pet-331", "count": 10},
}

def get_random_headers():
    return random.choice(HEADERS_LIST)

def fetch_page(url, retries=3):
    for i in range(retries):
        try:
            resp = requests.get(url, headers=get_random_headers(), timeout=15)
            if resp.status_code == 200:
                return resp.text
            print(f"HTTP {resp.status_code} for {url}", file=sys.stderr)
        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
        time.sleep(random.uniform(2, 5))
    return None

def parse_products(html, category):
    soup = BeautifulSoup(html, "lxml")
    products = []
    items = soup.select("[data-testid='product-card']") or soup.select(".product-card")
    for item in items:
        try:
            name = item.select_one("[data-testid='product-title']") or item.select_one(".product-title")
            price = item.select_one("[data-testid='product-price']") or item.select_one(".price")
            img = item.select_one("img")
            brand_el = item.select_one("[data-testid='product-brand']")
            products.append({
                "name": name.get_text(strip=True) if name else "",
                "price": re.sub(r"[^0-9.]", "", price.get_text()) if price else "0.00",
                "image": img.get("src", "") if img else "",
                "brand": brand_el.get_text(strip=True) if brand_el else "",
                "category": category,
            })
        except Exception:
            continue
    return products

if __name__ == "__main__":
    all_products = []
    for cat, cfg in CATEGORIES.items():
        print(f"Crawling {cat}...")
        html = fetch_page(cfg["url"])
        if html:
            products = parse_products(html, cat)[:cfg["count"]]
            all_products.extend(products)
            print(f"  Got {len(products)} products")
        time.sleep(random.uniform(1, 3))
    print(json.dumps(all_products, ensure_ascii=False, indent=2))
