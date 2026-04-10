package com.mojian.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.mojian.entity.SysAuthor;
import com.mojian.mapper.SysAuthorMapper;
import com.mojian.service.SysAuthorService;
import org.springframework.stereotype.Service;

@Service
public class SysAuthorServiceImpl extends ServiceImpl<SysAuthorMapper, SysAuthor> implements SysAuthorService {
}