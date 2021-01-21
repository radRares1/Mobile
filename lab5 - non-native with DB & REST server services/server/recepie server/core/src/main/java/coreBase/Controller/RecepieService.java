package coreBase.Controller;

import coreBase.Entities.Recepie;
import coreBase.Repository.RecepieRepo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class RecepieService {

    public static final Logger log = LoggerFactory.getLogger(RecepieService.class);


    @Autowired
    private RecepieRepo repo;


    public Optional<Recepie> getById(Integer recepieId) {
        return repo.findById(recepieId);

    }

    public List<Recepie> getAllRecepies() {
        log.trace("getAllRecepies - method entered");
        Iterable<Recepie> recepies = repo.findAll();

        log.trace("getAllClients - method finished");
        return (List<Recepie>) recepies;
    }

    public Recepie addRecepie(Recepie recepieToSave) throws Exception {
        try
        {

            log.trace("addRecepie - method entered with recepie :",recepieToSave);

            log.trace("addRecepie - method finished");
            return repo.save(recepieToSave);
        }
        catch(Exception v)
        {
            throw new Exception(v.getMessage());
        }

    }

    public void deleteRecepie(Integer recepieToDelete) throws Exception {
        try{
            log.trace("deleteRecepie - method entered with id :",recepieToDelete);
            repo.deleteById(recepieToDelete);
            log.trace("deleteRecepie - method finished");
        }
        catch (Exception v){
            throw  new Exception((v.getMessage()));
        }
    }

    @Transactional
    public Recepie updateRecepie(Recepie recepieToUpdate) throws Exception {

        log.trace("updateRecepie - method entered with recepie :",recepieToUpdate);

        repo.findById(recepieToUpdate.getId())
                .ifPresent(u -> {
                    u.setTitle(recepieToUpdate.getTitle());
                    u.setType(recepieToUpdate.getType());
                    u.setDescription(recepieToUpdate.getDescription());
                    u.setIngredients(recepieToUpdate.getIngredients());
                    log.debug("updateRecepie - updated: recepie={}", u);
                });

        log.trace("updateRecepie - method finished");
        return repo.findById(recepieToUpdate.getId()).get();

    }

}
