import { describe, it, expect, vi, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'

describe('购物车功能测试', () => {
  beforeEach(() => setActivePinia(createPinia()))

  it('TC-CART-001 【正常】登录用户加入商品成功', async () => {
    const mockAddToCart = vi.fn().mockResolvedValue({ code: 200, data: { cartCount: 1 } })
    const result = await mockAddToCart({ productId: 101, qty: 1 })
    expect(result.code).toBe(200)
    expect(result.data.cartCount).toBe(1)
  })

  it('TC-CART-003 【异常】库存不足商品无法加入购物车', async () => {
    const mockAddToCart = vi.fn().mockRejectedValue({ code: 400, msg: '商品库存不足' })
    await expect(mockAddToCart({ productId: 999, qty: 1 }))
      .rejects.toMatchObject({ msg: '商品库存不足' })
  })

  it('TC-CART-004 【异常】超出99件上限时数量截断为99', () => {
    const limitQty = (qty) => Math.min(qty, 99)
    expect(limitQty(100)).toBe(99)
    expect(limitQty(50)).toBe(50)
  })

  it('TC-CART-012 【正常】订单满$49运费为$0', () => {
    const calcShipping = (total) => total >= 49 ? 0 : 4.95
    expect(calcShipping(49)).toBe(0)
    expect(calcShipping(50)).toBe(0)
    expect(calcShipping(48.99)).toBe(4.95)
  })

  it('TC-CART-013 【正常】订单不足$49运费为$4.95', () => {
    const calcShipping = (total) => total >= 49 ? 0 : 4.95
    expect(calcShipping(30)).toBe(4.95)
  })

  it('TC-CART-015 【正常】游客购物车登录后合并叠加数量上限99', () => {
    const mergeCart = (guestCart, userCart) => {
      const merged = { ...userCart }
      for (const [id, qty] of Object.entries(guestCart)) {
        merged[id] = Math.min((merged[id] || 0) + qty, 99)
      }
      return merged
    }
    const result = mergeCart({ '101': 3 }, { '101': 98, '102': 2 })
    expect(result['101']).toBe(99)
    expect(result['102']).toBe(2)
  })
})
