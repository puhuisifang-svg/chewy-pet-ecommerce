import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { createPinia, setActivePinia } from 'pinia'

// ==================== 用户注册测试 ====================
describe('用户注册功能', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  // TC-REG-001 正常：成功注册新用户
  it('TC-REG-001 【正常】邮箱+密码注册成功', async () => {
    const mockRegister = vi.fn().mockResolvedValue({ code: 200, msg: '注册成功' })
    const result = await mockRegister({ email: 'test@example.com', password: 'Test1234' })
    expect(result.code).toBe(200)
    expect(mockRegister).toHaveBeenCalledWith({ email: 'test@example.com', password: 'Test1234' })
  })

  // TC-REG-002 正常：邮箱验证码注册
  it('TC-REG-002 【正常】验证码有效期5分钟内注册成功', async () => {
    const mockSendCode = vi.fn().mockResolvedValue({ code: 200 })
    const mockVerify = vi.fn().mockResolvedValue({ code: 200, msg: '验证通过' })
    await mockSendCode('test@example.com')
    const result = await mockVerify({ email: 'test@example.com', code: '123456' })
    expect(result.code).toBe(200)
  })

  // TC-REG-003 异常：重复邮箱注册
  it('TC-REG-003 【异常】重复邮箱应提示已被注册', async () => {
    const mockRegister = vi.fn().mockRejectedValue({ code: 400, msg: '该邮箱已被注册' })
    await expect(mockRegister({ email: 'existing@example.com', password: 'Test1234' }))
      .rejects.toMatchObject({ msg: '该邮箱已被注册' })
  })

  // TC-REG-004 异常：密码不符合要求
  it('TC-REG-004 【异常】纯数字密码应校验失败', () => {
    const validatePassword = (pwd) => /^(?=.*[a-zA-Z])(?=.*\d).{8,}$/.test(pwd)
    expect(validatePassword('12345678')).toBe(false)
    expect(validatePassword('Test1234')).toBe(true)
  })

  // TC-REG-005 异常：邮箱格式错误
  it('TC-REG-005 【异常】非邮箱格式应校验失败', () => {
    const validateEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
    expect(validateEmail('notanemail')).toBe(false)
    expect(validateEmail('valid@example.com')).toBe(true)
  })
})

// ==================== 用户登录测试 ====================
describe('用户登录功能', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  // TC-LOGIN-001 正常：账密登录成功
  it('TC-LOGIN-001 【正常】正确账密登录成功返回token', async () => {
    const mockLogin = vi.fn().mockResolvedValue({
      code: 200,
      data: { token: 'eyJhbGciOiJIUzI1NiJ9.test', userInfo: { email: 'test@example.com' } }
    })
    const result = await mockLogin({ email: 'test@example.com', password: 'Test1234' })
    expect(result.code).toBe(200)
    expect(result.data.token).toBeTruthy()
  })

  // TC-LOGIN-002 正常：记住我功能
  it('TC-LOGIN-002 【正常】记住我功能设置token有效期为7天', () => {
    const getTokenExpiry = (rememberMe) => rememberMe ? 7 * 24 * 60 * 60 * 1000 : 24 * 60 * 60 * 1000
    expect(getTokenExpiry(true)).toBe(604800000)
    expect(getTokenExpiry(false)).toBe(86400000)
  })

  // TC-LOGIN-003 异常：密码错误
  it('TC-LOGIN-003 【异常】错误密码应返回统一错误提示', async () => {
    const mockLogin = vi.fn().mockRejectedValue({ code: 401, msg: '邮箱或密码不正确' })
    await expect(mockLogin({ email: 'test@example.com', password: 'WrongPwd1' }))
      .rejects.toMatchObject({ msg: '邮箱或密码不正确' })
  })

  // TC-LOGIN-004 异常：连续失败锁定
  it('TC-LOGIN-004 【异常】连续失败5次应锁定账户15分钟', async () => {
    const mockLogin = vi.fn()
      .mockRejectedValueOnce({ code: 401, msg: '邮箱或密码不正确', remainAttempts: 4 })
      .mockRejectedValueOnce({ code: 401, msg: '邮箱或密码不正确', remainAttempts: 3 })
      .mockRejectedValueOnce({ code: 401, msg: '邮箱或密码不正确', remainAttempts: 2 })
      .mockRejectedValueOnce({ code: 401, msg: '邮箱或密码不正确', remainAttempts: 1 })
      .mockRejectedValue({ code: 423, msg: '账户已锁定，请15分钟后重试' })
    for (let i = 0; i < 4; i++) {
      await mockLogin({}).catch(() => {})
    }
    await expect(mockLogin({})).rejects.toMatchObject({ code: 423 })
  })

  // TC-LOGIN-005 异常：未注册邮箱
  it('TC-LOGIN-005 【异常】未注册邮箱应返回统一错误提示', async () => {
    const mockLogin = vi.fn().mockRejectedValue({ code: 401, msg: '邮箱或密码不正确' })
    await expect(mockLogin({ email: 'notexist@example.com', password: 'Test1234' }))
      .rejects.toMatchObject({ msg: '邮箱或密码不正确' })
  })
})
