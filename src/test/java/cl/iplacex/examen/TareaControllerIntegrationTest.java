package cl.iplacex.examen;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Pruebas de integración para los endpoints REST de tareas.
 */
@SpringBootTest
@AutoConfigureMockMvc
@DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
class TareaControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void deberiaListarTareasInicialmenteVacias() throws Exception {

        mockMvc.perform(get("/api/tareas"))
                .andExpect(status().isOk())
                .andExpect(content().json("[]"));
    }

    @Test
    void deberiaCrearUnaTareaMedianteApi() throws Exception {

        String json = """
                {
                    "titulo": "Ejecutar pruebas de integracion"
                }
                """;

        mockMvc.perform(post("/api/tareas")
                        .contentType("application/json")
                        .content(json))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.titulo")
                        .value("Ejecutar pruebas de integracion"))
                .andExpect(jsonPath("$.completada").value(false));
    }
}