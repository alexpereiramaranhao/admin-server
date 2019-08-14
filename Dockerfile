FROM openjdk:8-jdk-alpine

ENV jar_file target/admin-server-0.0.1-SNAPSHOT.jar
ARG jar_file=$jar_file

# Inicio: Configuracoes Gerais Spring Cloud

ENV spring_application_name admin-server
ARG spring_application_name=$spring_application_name

ENV spring_profiles_active homolog
ARG spring_profiles_active=$spring_profiles_active

ENV spring_cloud_config_uri http://ocb-config.ocb-config.svc:8080/
ARG spring_cloud_config_uri=$spring_cloud_config_uri

# FIM: Configuracoes Gerais Spring Cloud

RUN echo jar_file: $jar_file
RUN echo spring_application_name: $spring_application_name
RUN echo spring_profiles_active: $spring_profiles_active
RUN echo spring_cloud_config_uri: $spring_cloud_config_uri

COPY $jar_file app.jar

ENTRYPOINT [ \
	"java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar" \
	, "--spring.application.name=${spring_application_name}" \
	, "--spring.profiles.active=${spring_profiles_active}" \
	, "--spring.cloud.config.uri=${spring_cloud_config_uri}" \
]
