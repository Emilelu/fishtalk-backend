package org.fishtalk.web.domain.user.dto;

import lombok.Data;

@Data
public class ResetPasswordDTO {
    private String phone;
    private String newPassword;
} 