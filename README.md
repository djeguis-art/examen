\# Examen Final - Automatización de Pruebas



Proyecto desarrollado como parte del Examen Final de la asignatura Automatización de Pruebas.



El objetivo principal del trabajo es aplicar de manera práctica conceptos relacionados con control de versiones, automatización de pruebas, integración continua y despliegue continuo.



Para el desarrollo se implementó una API REST sencilla para la gestión de tareas, utilizando Java, Spring Boot y Maven. A partir de esta aplicación se incorporaron pruebas unitarias, pruebas de integración, acceptance tests y pipelines automatizados mediante GitHub Actions.



\---



\## Tecnologías utilizadas



\- Java 21

\- Spring Boot

\- Maven

\- JUnit 5

\- Spring Boot Test

\- MockMvc

\- Git

\- GitHub

\- GitHub Actions

\- Bash

\- Curl



\---



\## Estrategia de versionado



Se utilizó una estrategia basada en GitFlow simplificado.



La rama `main` representa la versión estable del proyecto, mientras que `develop` funciona como rama de integración.



Las distintas funcionalidades fueron desarrolladas en ramas independientes:



\- `feature/gestion-tareas`

\- `feature/pruebas-unitarias`

\- `feature/pruebas-integracion`

\- `feature/pipeline-ci`

\- `feature/deployment`

\- `feature/documentacion`



Una vez comprobado su correcto funcionamiento, cada funcionalidad fue integrada nuevamente a `develop`.



!\[Flujo Git](docs/evidencias/02-gitflow.png)



\---



\## Aplicación desarrollada



La aplicación corresponde a una API REST básica para la administración de tareas.



Cada tarea contiene:



\- Identificador.

\- Título.

\- Estado de completitud.



Los principales endpoints implementados son:



```text

GET  /api/tareas

POST /api/tareas

