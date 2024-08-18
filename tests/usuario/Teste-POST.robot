*** Settings ***
Resource    ../../resources/settings.robot
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords.robot



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