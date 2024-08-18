*** Settings ***
Resource     settings.robot
Resource    variables.robot
*** Keywords ***
#Keywords Login
Realizar login
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response_POST}    POST    url=https://serverest.dev/usuarios    json=&{body}

    &{body}    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    url=${ROST}/${LOGIN}    json=&{body}
    RETURN    ${response}
Realizar login email fora do padrão
    &{body}    Create Dictionary    email=teste.com    password=12345
    ${response}=    POST    url=${ROST}/${LOGIN}    json=&{body}
    RETURN    ${response}

Login com credenciais inválidas 
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response_POST}    POST    url=https://serverest.dev/usuarios    json=&{body}


    &{body}    Create Dictionary    email=${email}    password=123
    ${response}=    POST    url=${ROST}/${LOGIN}    json=&{body}
    RETURN    ${response}

Login com campos em branco 
    &{body}    Create Dictionary    email=    password=
    ${response}=    POST    url=${ROST}/${LOGIN}    json=&{body}
    RETURN    ${response}

#Keywords usuário DELETE
Deletar usuário cadastrado 
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response_POST}    POST    url=https://serverest.dev/usuarios    json=&{body}
    ${Response_json}    Set Variable    ${Response_POST.json()}
    ${Response_id}    Set Variable    ${Response_json["_id"]}

    ${Response}    DELETE   url=${ROST}/${USER}/${Response_id}
    RETURN    ${Response}

Deletar usuário inexistente
    ${Response}    DELETE   url=${ROST}/${USER}/1234567891021
    RETURN    ${Response}

#keywords usuário GET
Listar todos os usuários     
    ${Response}     GET   url=${ROST}/${ALL_USER}    
    RETURN    ${Response}

Lista pelo nome ${nome}
    ${USER_NAME}=     Replace String    ${USER_NAME}    id-nome    ${nome}
    ${Response}=     GET   url=${ROST}/${USER_NAME}
    RETURN    ${Response}

Listar usuários pelo e-mail ${email}
    ${USER_EMAIL}=     Replace String    ${USER_EMAIL}    id-email    ${email}
    ${Response}=     GET   url=${ROST}/${USER_EMAIL}
    RETURN    ${Response}

Listar usuários pelo id ${id}
    ${USER_ID}=     Replace String    ${USER_ID}    id-usuario    ${id}
    ${Response}=     GET   url=${ROST}/${USER_ID}
    RETURN    ${Response}

Listar usuario ADM ${id}
    ${USER_ADM}=     Replace String    ${USER_ADM}    id-adm    ${id}
    ${Response}=     GET   url=${ROST}/${USER_ADM}
    RETURN    ${Response}

Listar usuario com todos os parametros  
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    Set Global Variable    ${nome_global}    ${nome} 
    Set Global Variable    ${email_global}    ${email} 
    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    POST    url=https://serverest.dev/usuarios    json=&{body}

    ${USER_ALL_FILTERS}=     Replace String    ${USER_ALL_FILTERS}    id-nome   ${nome}
    ${USER_ALL_FILTERS}=     Replace String    ${USER_ALL_FILTERS}    id-email   ${email}
    ${USER_ALL_FILTERS}=     Replace String    ${USER_ALL_FILTERS}    id-adm   true
    ${Response}=     GET   url=${ROST}/${USER_ALL_FILTERS}
    RETURN    ${Response}

Buscar usuário pelo ID
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response_POST}    POST    url=https://serverest.dev/usuarios    json=&{body}
    ${Response_json}    Set Variable    ${Response_POST.json()}
    ${Response_id}    Set Variable    ${Response_json["_id"]}
    Set Global Variable    ${id_global}    ${Response_id}
    
    ${Response}=     GET   url=${ROST}/${ALL_USER}/${Response_id}
    RETURN    ${Response}
Busca usuário pelo ID inválido
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    POST    url=https://serverest.dev/usuarios    json=&{body}
    
    ${Response}=     GET   url=${ROST}/${ALL_USER}/teste
    RETURN    ${Response}
    
#Keywords usuário POST
Cadastro de usuário ADM
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5   

    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Request}    POST    url=${ROST}/${USER}    headers=&{header}   json=&{body}
    RETURN    ${Request}
    
Cadastro de usuário comum
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5   

    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=false
    ${Request}    POST    url=${ROST}/${USER}    headers=&{header}   json=&{body}
    RETURN    ${Request}

Campos em branco
    [Arguments]    ${nome}    ${email}    ${password}    ${adm}
    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${adm}
    ${Request}    POST    url=${ROST}/${USER}    headers=&{header}   json=&{body}
    RETURN    ${Request}

E-mail repetido
    ${nome}=    FakerLibrary.Name   
    ${password}=    FakerLibrary.Password    5   

    &{header}    Create Dictionary    Content-type=application/json
    &{body}    Create Dictionary    nome=${nome}    email=fulano@qa.com    password=${password}    administrador=false
    ${Request}    POST    url=${ROST}/${USER}    headers=&{header}   json=&{body}
    RETURN    ${Request}

Campos obrigatórios 
    &{header}    Create Dictionary    Content-type=application/json
    ${Request}    POST    url=${ROST}/${USER}    headers=&{header} 
    RETURN    ${Request}
#Keywords usuário PUT
Editar cadastro existente 
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response_POST}    POST    url=https://serverest.dev/usuarios    json=&{body}
    ${Response_json}    Set Variable    ${Response_POST.json()}
    ${Response_id}    Set Variable    ${Response_json["_id"]}

    ${nome_put}=    FakerLibrary.Name   
    ${email_put}=      FakerLibrary.Email   
    ${password_put}=    FakerLibrary.Password    5 
    &{body_put}    Create Dictionary    nome=${nome_put}    email=${email_put}   password=${password_put}      administrador=false    
    ${Response}    PUT  url=${ROST}/${USER}/${Response_id}    json=&{body_put}
    RETURN    ${Response}

Editar cadastro inexistente
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response}    PUT  url=${ROST}/${USER}/123    json=&{body}
    RETURN    ${Response}

Editar usuário para e-mail ja cadastrado 
    #primeiro put POST para obter o ID 
    ${nome}=    FakerLibrary.Name   
    ${email}=      FakerLibrary.Email   
    ${password}=    FakerLibrary.Password    5  
    &{body}    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=true
    ${Response_POST}    POST    url=https://serverest.dev/usuarios    json=&{body}
    ${Response_json}    Set Variable    ${Response_POST.json()}
    ${Response_id}    Set Variable    ${Response_json["_id"]}
    #Segundo POST para obter o e-mail repetido
    ${nome2}=    FakerLibrary.Name   
    ${email2}=      FakerLibrary.Email   
    ${password2}=    FakerLibrary.Password    5 
    &{body2}    Create Dictionary    nome=${nome2}    email=${email2}    password=${password2}    administrador=true
    POST    url=https://serverest.dev/usuarios    json=&{body2}

    ${nome_put}    FakerLibrary.Name
    ${password_put}    FakerLibrary.Password    5
    &{body_put}    Create Dictionary    nome=${nome_put}    email=${email2}  password=${password_put}      administrador=false    
    ${Response}    PUT  url=${ROST}/${USER}/${Response_id}    json=&{body_put}
    RETURN    ${Response}
