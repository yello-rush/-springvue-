package com.mojian.service.impl;

import java.util.List;

import cn.dev33.satoken.secure.BCrypt;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import com.mojian.mapper.SysAlbumMapper;
import com.mojian.entity.SysAlbum;
import com.mojian.service.SysAlbumService;
import com.mojian.utils.PageUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import lombok.RequiredArgsConstructor;

/**
 * 相册 服务实现类
 */
@Service
@RequiredArgsConstructor
public class SysAlbumServiceImpl extends ServiceImpl<SysAlbumMapper, SysAlbum> implements SysAlbumService {

    /**
     * 查询相册分页列表
     */
    @Override
    public IPage<SysAlbum> selectPage(SysAlbum sysAlbum) {
        LambdaQueryWrapper<SysAlbum> wrapper = new LambdaQueryWrapper<>();
        // 构建查询条件
        wrapper.select(SysAlbum::getId, SysAlbum::getName, SysAlbum::getDescription, SysAlbum::getIsLock,
                SysAlbum::getSort, SysAlbum::getCreateTime,SysAlbum::getCover);
        
        if (StringUtils.isNotBlank(sysAlbum.getName())) {
            wrapper.like(SysAlbum::getName, sysAlbum.getName());
        }
        
        wrapper.orderByAsc(SysAlbum::getSort).orderByDesc(SysAlbum::getCreateTime);
        return page(PageUtil.getPage(), wrapper);
    }

    /**
     * 查询相册列表
     */
    @Override
    public List<SysAlbum> selectList(SysAlbum sysAlbum) {
        LambdaQueryWrapper<SysAlbum> wrapper = new LambdaQueryWrapper<>();
        
        if (sysAlbum != null) {
            if (StringUtils.isNotBlank(sysAlbum.getName())) {
                wrapper.like(SysAlbum::getName, sysAlbum.getName());
            }
            if (sysAlbum.getIsLock() != null) {
                wrapper.eq(SysAlbum::getIsLock, sysAlbum.getIsLock());
            }
        }
        
        wrapper.orderByAsc(SysAlbum::getSort).orderByDesc(SysAlbum::getCreateTime);
        return list(wrapper);
    }

    /**
     * 新增相册
     */
    @Override
    public boolean insert(SysAlbum sysAlbum) {
        if (StringUtils.isNotBlank(sysAlbum.getPassword())) {
            sysAlbum.setPassword(BCrypt.hashpw(sysAlbum.getPassword()));
        }
        return save(sysAlbum);
    }

    /**
     * 修改相册
     */
    @Override
    public boolean update(SysAlbum sysAlbum) {
        if (StringUtils.isNotBlank(sysAlbum.getPassword())) {
            sysAlbum.setPassword(BCrypt.hashpw(sysAlbum.getPassword()));
        }
        return updateById(sysAlbum);
    }

    /**
     * 批量删除相册
     */
    @Override
    public boolean deleteByIds(List<Long> ids) {
        return removeByIds(ids);
    }
}
