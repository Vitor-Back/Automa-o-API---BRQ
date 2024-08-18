*** Variables ***
${ROST}    https://serverest.dev

#Rota Login
${LOGIN}    login
#Rota DELETE
${USER}    usuarios

#Rota GET
${ALL_USER}    usuarios
${USER_NAME}    usuarios?nome=id-nome
${USER_EMAIL}    usuarios?email=id-email
${USER_ADM}    usuarios?administrador=id-adm
${USER_ID}    usuarios?_id=id-usuario
${USER_ALL_FILTERS}    usuarios?nome=id-nome&email=id-email&administrador=id-adm