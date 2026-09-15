package cl.iplacex.examen;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Pruebas unitarias para la lógica de gestión de tareas.
 */
class TareaServiceTest {

    @Test
    void deberiaCrearUnaTareaCorrectamente() {

        TareaService service = new TareaService();

        Tarea tarea = service.crear("Configurar pipeline CI");

        assertNotNull(tarea);
        assertEquals(1L, tarea.getId());
        assertEquals("Configurar pipeline CI", tarea.getTitulo());
        assertFalse(tarea.isCompletada());
    }

    @Test
    void deberiaRechazarTituloVacio() {

        TareaService service = new TareaService();

        IllegalArgumentException excepcion = assertThrows(
                IllegalArgumentException.class,
                () -> service.crear("")
        );

        assertEquals(
                "El titulo de la tarea no puede estar vacio",
                excepcion.getMessage()
        );
    }
}