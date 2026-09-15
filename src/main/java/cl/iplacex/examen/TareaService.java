package cl.iplacex.examen;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Servicio encargado de gestionar las tareas de la aplicación.
 */
@Service
public class TareaService {

    private final List<Tarea> tareas = new ArrayList<>();
    private long siguienteId = 1;

    public List<Tarea> listar() {
        return tareas;
    }

    public Tarea crear(String titulo) {

        if (titulo == null || titulo.isBlank()) {
            throw new IllegalArgumentException(
                    "El titulo de la tarea no puede estar vacio"
            );
        }

        Tarea tarea = new Tarea(
                siguienteId++,
                titulo,
                false
        );

        tareas.add(tarea);

        return tarea;
    }
}