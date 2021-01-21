package clientBase.Ui;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import webBase.dto.RecepieDto;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;

/**
 * @author Rares2.
 */
@Component
public class UserInterface {

    private RestTemplate rest;
    public static final String RecepieURL = "http://192.168.1.5:5000/api/recepies";

    public UserInterface(RestTemplate restTemplate) {
        rest = restTemplate;
    }

    public void runConsole() throws Exception {

        while (true) {
            System.out.println(" 18 - add recepie");
            System.out.println(" 19 - print recepies");
            System.out.println(" 0 - exit");
            System.out.println("Input command: ");
            BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));

            try {
                int command = Integer.parseInt(bufferRead.readLine());
                if (command == 18) {
                    addRecepie();
                } else if (command == 19) {
                    printAllRecepies();
                }
                else break;

            } catch (IOException | SQLException ex) {
                ex.printStackTrace();
            }

        }
    }

    private String readRecepie() {
        System.out.println("Read recepie {title, type, ingredients, a}");

        BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
        try {

            String title = bufferRead.readLine();
            String type = bufferRead.readLine();
            String ingredients = bufferRead.readLine();
            String description = bufferRead.readLine();

            var idk = new RecepieDto(title, type,ingredients,description);

            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.writeValueAsString(idk);

            //return new RecepieDto(title, type,ingredients,description);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private void addRecepie() throws Exception{
        String recepie = readRecepie();
        try {
            String recepieToSave = rest.postForObject(
                    RecepieURL,
                    recepie,
                    String.class);
            System.out.println("Recepie" + recepie + "was added");
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    private void printAllRecepies() throws Exception {
        String allRecepies = rest.getForObject(RecepieURL, String.class);
        System.out.println(allRecepies);
    }


}


