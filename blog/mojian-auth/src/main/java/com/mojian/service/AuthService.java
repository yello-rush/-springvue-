package com.mojian.service;

import com.mojian.dto.Captcha;
import com.mojian.dto.EmailRegisterDto;
import com.mojian.dto.LoginDTO;
import com.mojian.dto.user.LoginUserInfo;

import javax.mail.MessagingException;

public interface AuthService {

    /**
     * 用户登录
     */
    LoginUserInfo login(LoginDTO loginDTO);

    /**
     * 获取当前登录用户信息
     */
    LoginUserInfo getLoginUserInfo(String source);

    /**
     * 发送注册邮箱验证码
     * @param email
     * @return
     */
    Boolean sendEmailCode(String email) throws MessagingException;

    /**
     * 邮箱账号注册
     * @param dto
     * @return
     */
    Boolean register(EmailRegisterDto dto);

    /**
     * 邮箱账号重置密码
     * @param dto
     * @return
     */
    Boolean forgot(EmailRegisterDto dto);

    /**
     * 获取滑块验证码
     * @return
     */
    Captcha getCaptcha();

    /**
     * 微信登录
     */
    String wechatLogin(me.chanjar.weixin.mp.bean.message.WxMpXmlMessage message);
}
