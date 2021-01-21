package webBase.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
public class RecepieDto extends BaseDto {

    private String title;
    private String type;
    private String ingredients;
    private String description;

}
