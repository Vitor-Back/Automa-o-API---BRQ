*** Settings ***

Library    requests
Library    String
Library    FakerLibrary    locale=pt_br

*** Variables ***
${ROST}    https://serverest.dev

#Rota
${ALL_USER}    usuarios
${USER_NAME}    usuarios?nome=id-nome
${USER_EMAIL}    usuarios?email=id-email
${USER_ADM}    usuarios?administrador=id-adm
${USER_ID}    usuarios?_id=id-usuario
${USER_ALL_FILTERS}    usuarios?nome=id-nome&email=id-email&administrador=id-adm



*** Keywords ***
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

*** Test Cases ***
TC01 - Listar todos os usuários 
    ${Response}    Listar todos os usuários 
    Should Be Equal As Numbers    ${Response.status_code}    200

TC02 - Listar usuários pelo nome 
    ${Response}   Lista pelo nome Fulano da Silva
    Should Be Equal As Numbers    ${Response.status_code}    200
    ##Should Be Equal As Numbers    ${Response.json()["quantidade"]}  1  
    Should Not Be Empty     ${Response.json()["usuarios"]}       
    Should Be Equal As Strings    ${Response.json()["usuarios"][0]["nome"]}   Fulano da Silva 

    [Documentation]    Validar usuários inexistentes 
    ${Response}   Lista pelo nome jober
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Empty    ${Response.json()["usuarios"]}
    

TC03 - Listar usuário pelo e-mail 
    ${Response}    Listar usuários pelo e-mail fulano@qa.com
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Numbers    ${Response.json()["quantidade"]}  1
    Should Not Be Empty     ${Response.json()["usuarios"]}  
    Should Be Equal As Strings    ${Response.json()["usuarios"][0]["email"]}   fulano@qa.com 

    [Documentation]    E-mail inexiste 
    ${Response}   Lista pelo nome dsafas
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Empty    ${Response.json()["usuarios"]}
 
TC03.1 - Validar e-mail
    ${Response}    Listar usuários pelo e-mail fulan
    Should Be Equal As Numbers    ${Response.status_code}    400
    Should Be Equal As Strings    ${Response.json()["email"]}     email deve ser um email válido   

TC04 - Listar usuário pelo id
    ${Response}   Listar usuários pelo id 0uxuPY0cbmQhpEz1
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["usuarios"][0]["_id"]}   0uxuPY0cbmQhpEz1

    [Documentation]    Validar id inexistente
    ${Response}    Listar usuários pelo id 0uxuPY0cbm66666
    Should Be Equal As Numbers    ${Response.json()["quantidade"]}  0
    Should Be Empty     ${Response.json()["usuarios"]}      
TC05 - Listar usuário ADM 
    ${Response}    Listar usuario ADM true
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings     ${Response.json()["usuarios"][0]["administrador"]}    true

TC06 - Listar somente usuário comum
    ${Response}    Listar usuario ADM false
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["usuarios"][0]["administrador"]}     false  


TC07 - Listar usuário com todos os parameros 
    
    ${Response}    Listar usuario com todos os parametros    
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["usuarios"][0]["nome"]}    ${nome_global}    # robotcode: ignore
    Should Be Equal As Strings    ${Response.json()["usuarios"][0]["email"]}    ${email_global}    # robotcode: ignore