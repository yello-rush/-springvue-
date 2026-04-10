package com.mojian.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.entity.SysNotice;
import com.mojian.mapper.SysNoticeMapper;
import com.mojian.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final SysNoticeMapper baseMapper;

    @Override
    public List<SysNotice> getNoticeList() {
        return baseMapper.selectList(new LambdaQueryWrapper<SysNotice>()
                .eq(SysNotice::getIsShow, 1)
                .orderByAsc(SysNotice::getSort)
                .orderByDesc(SysNotice::getCreateTime));
    }
}