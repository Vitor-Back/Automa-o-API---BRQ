*** Settings ***

Library    requests
Library    String
Library    FakerLibrary    locale=pt_BR

*** Variables ***
${ROST}    https://serverest.dev

#rotas
${USER}    usuarios

*** Keywords ***

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

*** Test Cases ***
TC01 - Cadastrar usuário ADM
    ${Request}    Cadastro de usuário ADM
    Should Be Equal As Numbers    ${Request.status_code}    201
    Should Be Equal As Strings    ${Request.json()["message"]}    Cadastro realizado com sucesso


TC02 - Cadastrar usuário Comum
    ${Request}    Cadastro de usuário comum
    Should Be Equal As Numbers    ${Request.status_code}    201
    Should Be Equal As Strings    ${Request.json()["message"]}    Cadastro realizado com sucesso

TC03 - Cadastro de usuário - campos em branco 
    ${Request}    Campos em branco    nome=    email=     password=     adm=
    Should Be Equal As Numbers    ${Request.status_code}    400
    Should Be Equal As Strings    ${Request.json()["nome"]}    nome não pode ficar em branco
    Should Be Equal As Strings    ${Request.json()["email"]}    email não pode ficar em branco
    Should Be Equal As Strings    ${Request.json()["password"]}    password não pode ficar em branco
    Should Be Equal As Strings    ${Request.json()["administrador"]}    administrador deve ser 'true' ou 'false'

    [Documentation]    Validar cada campo em branco 
    ${Request}    Campos em branco    nome=    email=leona@brq.com     password=12345     adm=true
    Should Be Equal As Numbers    ${Request.status_code}    400
    Should Be Equal As Strings    ${Request.json()["nome"]}    nome não pode ficar em branco

    ${Request}    Campos em branco    nome=Leona    email=     password=12345     adm=true
    Should Be Equal As Numbers    ${Request.status_code}    400
    Should Be Equal As Strings    ${Request.json()["email"]}    email não pode ficar em branco

    ${Request}    Campos em branco    nome=Leona    email=leona@brq.com     password=    adm=true
    Should Be Equal As Numbers    ${Request.status_code}    400
    Should Be Equal As Strings    ${Request.json()["password"]}    password não pode ficar em branco

    ${Request}    Campos em branco    nome=Leona    email=leona@brq.com     password=12345     adm=
    Should Be Equal As Numbers    ${Request.status_code}    400
    Should Be Equal As Strings    ${Request.json()["administrador"]}    administrador deve ser 'true' ou 'false'

TC04 - Cadastrar usuário com mesmo e-mail 
    ${Response}    E-mail repetido
    Should Be Equal As Numbers    ${Response.status_code}    400
    Should Be Equal As Strings    ${Response.json()["message"]}    Este email já está sendo usado

TC05 - Campos obrigatórios 
    ${Response}    Campos obrigatórios 
    Should Be Equal As Numbers    ${Response.status_code}    400
    Should Be Equal As Strings    ${Response.json()["nome"]}    nome é obrigatório
    Should Be Equal As Strings    ${Response.json()["email"]}    email é obrigatório
    Should Be Equal As Strings    ${Response.json()["password"]}    password é obrigatório
    Should Be Equal As Strings    ${Response.json()["administrador"]}    administrador é obrigatório