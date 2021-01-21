package webBase.converter;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import coreBase.Entities.Recepie;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

@Component
public class RecepieJSONConverter {

     public String convertModelToDto(Recepie recepie) throws JsonProcessingException {
         ObjectMapper objectMapper = new ObjectMapper();
         return objectMapper.writeValueAsString(recepie);
     }

     public Recepie convertDtoToModel(String recepieJSON) throws IOException {
         System.out.println(recepieJSON);
         ObjectMapper objectMapper = new ObjectMapper();
         Recepie recepie = objectMapper.readValue(recepieJSON,Recepie.class);
         System.out.println(recepie.getId());
         return recepie;
     }

     public String convertModelsToDtos(List<Recepie> recepies) throws JsonProcessingException {
         ObjectMapper objectMapper = new ObjectMapper();

         return objectMapper.writeValueAsString(recepies);
     }

}