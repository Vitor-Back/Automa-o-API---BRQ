*** Settings ***

Resource    ../../resources/settings.robot
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords.robot


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
    ${Response}   Listar usuários pelo e-mail vanessa.brq@brq.com
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Empty    ${Response.json()["usuarios"]}
 

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

TC08 - Listar usuário pelo ID 
    ${Response}    Buscar usuário pelo ID
    Should Be Equal As Numbers    ${Response.status_code}    200
    Should Be Equal As Strings    ${Response.json()["_id"]}    ${id_global}    # robotcode: ignore
    
    [Documentation]    Validar busca de ID inexistente
    ${Response}    Busca usuário pelo ID inválido
    Should Be Equal As Numbers    ${Response.status_code}    400
    Should Be Equal As Strings    ${Response.json()["message"]}     Usuário não encontrado