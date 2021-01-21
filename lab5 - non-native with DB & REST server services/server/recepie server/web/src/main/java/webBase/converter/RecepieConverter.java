package webBase.converter;

import coreBase.Entities.Recepie;
import org.springframework.stereotype.Component;
import webBase.dto.RecepieDto;

@Component
public class RecepieConverter extends BaseConverter<Recepie, RecepieDto> {
    @Override
    public Recepie convertDtoToModel(RecepieDto dto) {
        Recepie recepie = Recepie.builder()
                .title(dto.getTitle())
                .type(dto.getType())
                .ingredients(dto.getIngredients())
                .description(dto.getDescription())
                .build();
        recepie.setId(dto.getId());
        return recepie;
    }

    @Override
    public RecepieDto convertModelToDto(Recepie recepie) {
        RecepieDto dto = RecepieDto.builder()
                .title(recepie.getTitle())
                .type(recepie.getType())
                .ingredients(recepie.getIngredients())
                .description(recepie.getDescription())
                .build();
        dto.setId(recepie.getId());
        return dto;
    }
}