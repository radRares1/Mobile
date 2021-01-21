package webBase.controller;

import coreBase.Controller.RecepieService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import webBase.converter.RecepieJSONConverter;

@RestController
public class RecepieController {

    public static final Logger log= LoggerFactory.getLogger(RecepieController.class);

    @Autowired
    private RecepieService recepieService;

    @Autowired
    private RecepieJSONConverter recepieConverter;

    @RequestMapping(value = "/recepies", method = RequestMethod.GET)
    String getRecepies() throws Exception{
        System.out.println("got in get");
        log.trace("got in get recepies");
        return recepieConverter.convertModelsToDtos(recepieService.getAllRecepies());
    }

    @RequestMapping(value = "/recepies", method = RequestMethod.POST)
    String addRecepie(@RequestBody String recepieJSON) throws Exception {
        log.trace("got to add recepie");
        return recepieConverter.convertModelToDto(recepieService.addRecepie(
                recepieConverter.convertDtoToModel(recepieJSON)
        ));
    }

    @RequestMapping(value = "/recepies", method = RequestMethod.PUT)
    String updateRecepie(@RequestBody String recepieJSON) throws Exception {
        log.trace("got to update recepie");
        return recepieConverter.convertModelToDto(recepieService.updateRecepie(
                recepieConverter.convertDtoToModel(recepieJSON)
        ));
    }

    @RequestMapping(value = "/recepies/{id}", method = RequestMethod.DELETE)
    ResponseEntity<?> deleteMovie(@PathVariable Integer id) throws Exception {
        System.out.println(id);
        recepieService.deleteRecepie(id);
        System.out.println("got to delete recepie");
        return new ResponseEntity<>(HttpStatus.OK);
    }

}
