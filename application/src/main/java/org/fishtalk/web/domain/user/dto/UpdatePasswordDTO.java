package org.fishtalk.web.domain.user.dto;

import lombok.Data;

@Data
public class UpdatePasswordDTO {
    private Long userId;
    private String oldPassword;
    private String newPassword;
} 