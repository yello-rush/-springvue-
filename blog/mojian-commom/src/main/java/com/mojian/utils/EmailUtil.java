package com.mojian.utils;

import com.mojian.common.RedisConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.*;
import javax.mail.internet.MimeMessage;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

/**
 * @author: quequnlong
 * @date: 2024/12/28
 * @description: 邮箱工具类
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class EmailUtil {


    @Value("${mail.smtp.email}")
    private String fromEmail;

    @Value("${mail.smtp.password}")
    private String password;

    @Value("${mail.smtp.port}")
    private int port;

    @Value("${mail.smtp.host}")
    private String host;

    private final RedisUtil redisUtil;

    private final JavaMailSenderImpl javaMailSender = new JavaMailSenderImpl();



    public void getJavaMailSenderImpl(){
        javaMailSender.setHost(host);
        javaMailSender.setUsername(fromEmail);
        javaMailSender.setPassword(password);
        javaMailSender.setPort(port);
        javaMailSender.setDefaultEncoding("UTF-8");
        Properties p = new Properties();
        p.setProperty("mail.smtp.auth", "true");
        p.setProperty("mail.debug", "true");
        javaMailSender.setJavaMailProperties(p);
    }

    /**
     * 发送验证码
     * @param email
     * @throws MessagingException
     */
    public void sendCode(String email) throws MessagingException {

        this.getJavaMailSenderImpl();

        int code = (int) ((Math.random() * 9 + 1) * 100000);
        String content = "<html>\n" +
                "<body>\n" +
                "  <div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 10px;\">\n" +
                "    <h2 style=\"color: #409EFF; text-align: center;\">验证您的邮箱</h2>\n" +
                "    <p style=\"font-size: 16px; color: #333;\">您好！</p>\n" +
                "    <p style=\"font-size: 16px; color: #333;\">您正在进行注册/找回密码操作，您的验证码是：</p>\n" +
                "    <div style=\"text-align: center; margin: 20px 0;\">\n" +
                "      <span style=\"display: inline-block; padding: 15px 30px; font-size: 28px; font-weight: bold; color: #409EFF; background-color: #f4f4f5; border-radius: 8px; letter-spacing: 5px;\">" + code + "</span>\n" +
                "    </div>\n" +
                "    <p style=\"font-size: 14px; color: #999;\">该验证码将在 3 分钟后失效。请勿将验证码泄露给他人。</p>\n" +
                "    <hr style=\"border: none; border-top: 1px solid #eee; margin: 30px 0;\">\n" +
                "    <p style=\"font-size: 12px; color: #ccc; text-align: center;\">此邮件由系统自动发送，请勿回复。</p>\n" +
                "  </div>\n" +
                "</body>\n" +
                "</html>";

        // 创建邮件消息
        this.send(email, content);
        log.info("邮箱验证码发送成功,邮箱:{},验证码:{}",email,code);

        redisUtil.set(RedisConstants.CAPTCHA_CODE_KEY + email, code +"");
        redisUtil.expire(RedisConstants.CAPTCHA_CODE_KEY + email, RedisConstants.MINUTE_EXPIRE, TimeUnit.SECONDS);
    }

    private void send(String email, String template) throws MessagingException {

        //创建一个MINE消息
        MimeMessage mimeMessage = javaMailSender.createMimeMessage();
        MimeMessageHelper mineHelper = new MimeMessageHelper(mimeMessage, true);
        // 设置邮件主题
        mineHelper.setSubject("您有一封来自 习习中博客 的回执！");
        // 设置邮件发送者
        mineHelper.setFrom(Objects.requireNonNull(javaMailSender.getUsername()));
        // 设置邮件接收者，可以有多个接收者，中间用逗号隔开
        mineHelper.setTo(email);
        // 设置邮件发送日期
        mineHelper.setSentDate(DateUtil.getNowDate());
        // 设置邮件的正文
        mineHelper.setText(template,true);
        // 发送邮件
        javaMailSender.send(mimeMessage);
    }


}
