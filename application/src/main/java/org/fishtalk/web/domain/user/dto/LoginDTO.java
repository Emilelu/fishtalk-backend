package org.fishtalk.web.domain.user.dto;

import lombok.Data;

@Data
public class LoginDTO {
    private String phone;
    private String password;
} 