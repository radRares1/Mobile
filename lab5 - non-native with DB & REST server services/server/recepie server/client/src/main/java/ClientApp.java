import clientBase.Ui.UserInterface;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.web.client.RestTemplate;

public class ClientApp {


    public static void main(String[] args) throws Exception {

        AnnotationConfigApplicationContext context =
                new AnnotationConfigApplicationContext(
                        "clientBase.config"
                );

        RestTemplate restTemplate = context.getBean(RestTemplate.class);

        UserInterface ui  = new UserInterface(restTemplate);

        ui.runConsole();

    }
}
