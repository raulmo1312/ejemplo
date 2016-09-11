# Login_FORM_with_fileRealm_users_and_roles
Ejemplo de Autenticación (Login) Usuario contraseña con Roles Admin y User en JEE con Glashfish

    Proyecto basado en https://netbeans.org/kb/docs/web/security-webapps.html 
        NO MUESTRA COMO FUNCIONAR CON MAPEOS DE GRUPOS A ROLES.
        YO LO HE ADAPTADO PARA QUE FUNCIONE CON MAPEOS DE GRUPOS A ROLES:
        
        
        IMPORTANTE PARA QUE FUNCIONES ESTE EJEMPLO:
          Crear en el servidor GlashFish:
          
          Nombre del Dominio(Realm): filePrueba
            Nombre de la Clase: com.sun.enterprise.security.auth.realm.file.FileRealm
            Propiedades específicas de esta clase:  
                Contexto JAAS:   fileRealm
                Archivo Clave:   $ {com.sun.aas.instanceRoot}/config/keyfile
          
            Crear usuarios  (ID, password, lista de grupos):
              (admin,admin,)
              (user,user,)
              (jose,jose,ADMIN)
              (pepe,pepe,USER)
                 
          Contenido del fichero de claves una vez se han dado de alta a los usuarios
          en el nuevo domino:
          
            admin;{SSHA256}SkTvOUgHOrNjWgGudauUw8Onlh5UK73Xjr8+ILtNwvzXriEXHq8RNg==;
            user;{SSHA256}WxbwhMvlA+REOUb0i9E/G7R/3xgIhgZ1IfkXLCz2amGoHfd4PC/gVQ==;
            jose;{SSHA256}QnY5ucNiZdhJB2SCGYKmS5Ho2Qc7jQEj/VAICHiYKBTYlcGMG+v9kA==;ADMIN
            pepe;{SSHA256}O+qWCOmuv+GfftDdZvuKiEUOeia+PnCJlfKHS52SOKsbq//UgCnpAA==;USER
          
          Comprobaremos que el ID del usuario 'admin' es el <principal-name> en el mapeo con el rol 'AdminRole'.
          Mientras que el ID del usuario 'user' corresponde con el <principal-name> en el pamepo del rol 'UserRole'.
          Notese que ambos usuarios despues de la clave cifrada en con el algoritmo SSHA256 no tienen asigando 
          ningún grupo.
          Mientras que los usuarios con ID 'jose' y 'pepe' si tienen asignados el grupo 'ADMIN' y 'USER' 
          respectivamente. Y que están mapeados en el descripor específico del servidor 'sun-web.xml' 
          o 'glassfish-web.xml' con la etiqutea <group-name>
          Si no mapeamos el grupo ADMIN y USER asignados a los usuarios jose y pepe respectivamente en el fichero
          glassfish-web.xml con su correspondiente AdminRol y UserRol con la etiqueta <group-name>. Los usuarios 
          jose y pepe no podrán acceder a ningún recurso, puesto sus ID nos son lo <principal-name>.
        
        ---------------------------------------------
        DESCRIPTOR DE DESPLIEGUE DE LA APLICACIÓN WEB
        -------------web.xml--------------------
        <?xml version="1.0" encoding="UTF-8"?>
        <web-app version="3.0" xmlns="http://java.sun.com/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd">
            <session-config>
                <session-timeout>
                    30
                </session-timeout>
            </session-config>
            <security-constraint>
                <display-name>AdminConstraint</display-name>
                <web-resource-collection>
                    <web-resource-name>Admin</web-resource-name>
                    <description>Recursos a los que puede acceder un usuario administrador logado</description>
                    <url-pattern>/secureAdmin/*</url-pattern>
                </web-resource-collection>
                <auth-constraint>
                    <description/>
                    <role-name>AdminRole</role-name>
                </auth-constraint>
            </security-constraint>
            <security-constraint>
                <display-name>UserConstraint</display-name>
                <web-resource-collection>
                    <web-resource-name>User</web-resource-name>
                    <description>Acceso a las páginas de usuario normal logeado en el sistema</description>
                    <url-pattern>/secureUser/*</url-pattern>
                </web-resource-collection>
                <auth-constraint>
                    <description/>
                    <role-name>UserRole</role-name>
                </auth-constraint>
            </security-constraint>
            <login-config>
                <auth-method>FORM</auth-method>
                <realm-name>filePrueba</realm-name>
                <form-login-config>
                    <form-login-page>/login.jsp</form-login-page>
                    <form-error-page>/loginError.html</form-error-page>
                </form-login-config>
            </login-config>
            <security-role>
                <description>Users added to this role have access to the secureAdmin directory of the server.</description>
                <role-name>AdminRole</role-name>
            </security-role>
            <security-role>
                <description>Users added to this role have access to the secureUser directory of the server.</description>
                <role-name>UserRole</role-name>
            </security-role>
        </web-app>
  
  
        --------------------------------------------------------
        DESCRIPTOR DE DESPLIEGUE ESPECÍFICO DEL SERVIDOR 
        ---------------sun-web.xml o glassfish-web.xml----------
        <glassfish-web-app error-url="">
            <security-role-mapping>
                <role-name>AdminRole</role-name>
                <principal-name>admin</principal-name>
                <group-name>ADMIN</group-name>
            </security-role-mapping>
            <security-role-mapping>
                <role-name>UserRole</role-name>
                <principal-name>user</principal-name>
                <group-name>USER</group-name>
            </security-role-mapping>
            <class-loader delegate="true"/>
            <jsp-config>
                <property name="keepgenerated" value="true">
                <description>Keep a copy of the generated servlet class' java code.</description>
                </property>
            </jsp-config>
            </glassfish-web-app>        
        
