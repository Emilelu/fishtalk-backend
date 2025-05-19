package org.fishtalk.web.domain.user.dto;

import lombok.Data;

@Data
public class UpdateUsernameDTO {
    private Long userId;
    private String newUsername;
} 