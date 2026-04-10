package com.mojian.controller;

import com.alibaba.fastjson.JSON;
import com.mojian.common.Result;
import com.mojian.dto.LoginDTO;
import com.mojian.entity.SysUser;
import com.mojian.exception.ServiceException;
import com.mojian.service.AuthService;
import com.mojian.dto.user.LoginUserInfo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import com.mojian.exception.GlobalException;
import com.mojian.vo.error.ErrorReportVo;

import javax.servlet.http.HttpServletRequest;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
public class AuthControllerTest {

    private MockMvc mockMvc;

    @Mock
    private AuthService authService;

    @Mock
    private com.mojian.exception.ErrorReportManager errorReportManager;

    @InjectMocks
    private AuthController authController;

    @BeforeEach
    public void setup() {
        GlobalException globalException = new GlobalException(errorReportManager);
        // Mock error report manager behavior
        com.mojian.vo.error.ErrorReportVo mockReport = new com.mojian.vo.error.ErrorReportVo();
        Mockito.lenient().when(errorReportManager.record(any(), any())).thenReturn(mockReport);
        
        mockMvc = MockMvcBuilders.standaloneSetup(authController)
                .setControllerAdvice(globalException)
                .build();
    }

    @Test
    public void testLoginSuccess_Return200AndToken() throws Exception {
        LoginDTO loginDTO = new LoginDTO();
        loginDTO.setUsername("admin");
        loginDTO.setPassword("123456");

        LoginUserInfo mockInfo = new LoginUserInfo();
        mockInfo.setToken("mock-token-12345");
        mockInfo.setUsername("admin");

        Mockito.when(authService.login(any(LoginDTO.class))).thenReturn(mockInfo);

        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(JSON.toJSONString(loginDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andExpect(jsonPath("$.data.token").value("mock-token-12345"));
    }

    @Test
    public void testLoginWrongPassword_Return401() throws Exception {
        LoginDTO loginDTO = new LoginDTO();
        loginDTO.setUsername("admin");
        loginDTO.setPassword("wrong-password");

        Mockito.when(authService.login(any(LoginDTO.class)))
                .thenThrow(new ServiceException(401, "用户名或密码错误"));

        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(JSON.toJSONString(loginDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(401))
                .andExpect(jsonPath("$.message").value("用户名或密码错误"));
    }

    @Test
    public void testLoginDatabaseDisconnected_Return500() throws Exception {
        LoginDTO loginDTO = new LoginDTO();
        loginDTO.setUsername("admin");
        loginDTO.setPassword("123456");

        // Simulate database connection failure
        Mockito.when(authService.login(any(LoginDTO.class)))
                .thenThrow(new RuntimeException("Cannot create PoolableConnectionFactory"));

        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(JSON.toJSONString(loginDTO)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(500))
                .andExpect(jsonPath("$.message").value("系统错误"));
    }
}
