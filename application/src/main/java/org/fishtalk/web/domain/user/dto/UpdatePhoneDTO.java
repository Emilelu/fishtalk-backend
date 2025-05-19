package org.fishtalk.web.domain.user.dto;

import lombok.Data;

@Data
public class UpdatePhoneDTO {
    private Long userId;
    private String newPhone;
} 