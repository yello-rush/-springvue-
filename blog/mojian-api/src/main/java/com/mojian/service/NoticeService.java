package com.mojian.service;

import com.mojian.entity.SysNotice;
import java.util.List;

public interface NoticeService {
    List<SysNotice> getNoticeList();
}