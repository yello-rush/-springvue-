package com.mojian.exception;

public class ServiceException extends RuntimeException {
    
    private static final long serialVersionUID = 1L;

    private Integer code = 500;

    public ServiceException(String message) {
        super(message);
    }

    public ServiceException(int code, String message) {
        super(message);
        this.code = code;
    }

    public ServiceException(String message, Throwable cause) {
        super(message, cause);
    }

    public Integer getCode() {
        return code;
    }
} 