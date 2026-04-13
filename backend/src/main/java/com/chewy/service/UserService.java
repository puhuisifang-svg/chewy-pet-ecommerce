package com.chewy.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.chewy.dto.user.AddressRequest;
import com.chewy.dto.user.UpdateProfileRequest;
import com.chewy.entity.User;
import com.chewy.entity.UserAddress;
import com.chewy.mapper.UserAddressMapper;
import com.chewy.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserMapper userMapper;
    private final UserAddressMapper userAddressMapper;

    /** 获取用户信息 */
    public User getProfile(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) throw new RuntimeException("User not found");
        return user;
    }

    /** 更新用户信息 */
    public User updateProfile(Long userId, UpdateProfileRequest req) {
        User user = userMapper.selectById(userId);
        if (user == null) throw new RuntimeException("User not found");
        if (StringUtils.hasText(req.getUsername())) user.setUsername(req.getUsername());
        if (req.getFirstName() != null) user.setFirstName(req.getFirstName());
        if (req.getLastName() != null) user.setLastName(req.getLastName());
        if (req.getPhone() != null) user.setPhone(req.getPhone());
        if (req.getAvatar() != null) user.setAvatar(req.getAvatar());
        userMapper.updateById(user);
        return user;
    }

    /** 获取地址列表 */
    public List<UserAddress> listAddresses(Long userId) {
        return userAddressMapper.selectList(
            new LambdaQueryWrapper<UserAddress>()
                .eq(UserAddress::getUserId, userId)
                .orderByDesc(UserAddress::getIsDefault)
                .orderByDesc(UserAddress::getCreatedAt)
        );
    }

    /** 新增收货地址 */
    @Transactional
    public UserAddress addAddress(Long userId, AddressRequest req) {
        // 如果设为默认，先清除其他默认
        if (req.getIsDefault() != null && req.getIsDefault() == 1) {
            clearDefaultAddress(userId);
        }
        UserAddress address = new UserAddress();
        fillAddressFromRequest(address, req);
        address.setUserId(userId);
        userAddressMapper.insert(address);
        return address;
    }

    /** 编辑地址 */
    @Transactional
    public UserAddress updateAddress(Long userId, Long addressId, AddressRequest req) {
        UserAddress address = getAddressOrThrow(userId, addressId);
        if (req.getIsDefault() != null && req.getIsDefault() == 1) {
            clearDefaultAddress(userId);
        }
        fillAddressFromRequest(address, req);
        userAddressMapper.updateById(address);
        return address;
    }

    /** 删除地址 */
    @Transactional
    public void deleteAddress(Long userId, Long addressId) {
        UserAddress address = getAddressOrThrow(userId, addressId);
        userAddressMapper.deleteById(address.getId());
    }

    /** 设为默认地址 */
    @Transactional
    public UserAddress setDefaultAddress(Long userId, Long addressId) {
        UserAddress address = getAddressOrThrow(userId, addressId);
        clearDefaultAddress(userId);
        address.setIsDefault(1);
        userAddressMapper.updateById(address);
        return address;
    }

    // ---- private helpers ----

    private void fillAddressFromRequest(UserAddress address, AddressRequest req) {
        address.setFullName(req.getFullName());
        address.setPhone(req.getPhone());
        address.setAddressLine1(req.getAddressLine1());
        address.setAddressLine2(req.getAddressLine2());
        address.setCity(req.getCity());
        address.setState(req.getState());
        address.setZipCode(req.getZipCode());
        address.setCountry(req.getCountry() != null ? req.getCountry() : "US");
        address.setIsDefault(req.getIsDefault() != null ? req.getIsDefault() : 0);
    }

    private void clearDefaultAddress(Long userId) {
        userAddressMapper.update(null,
            new LambdaUpdateWrapper<UserAddress>()
                .eq(UserAddress::getUserId, userId)
                .eq(UserAddress::getIsDefault, 1)
                .set(UserAddress::getIsDefault, 0)
        );
    }

    private UserAddress getAddressOrThrow(Long userId, Long addressId) {
        UserAddress address = userAddressMapper.selectById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new RuntimeException("Address not found");
        }
        return address;
    }
}
