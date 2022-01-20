#!/bin/bash
#Seleciona as primeiras tags com o prefixo <name></name> e os valores internos
# com o SED o valor é editado, e rapidamente armazenado em uma variavel
#com isso, é possivel mudar especificamente o valor atraves do SED
while read NAME; do
[[ $NAME =~ \<name\>.*\<\/name\> ]] && \
        v1=`echo $NAME | sed 's/<.*>\(.*\)<\/.*>/\1/g'`
done < config.xml

while true; do
        echo -e "\e[33;1mQual o novo nome $v1? \e[m"
        read _newname

        echo -e '\e[33;1mEsse é o nome certo? \e[m'
        echo -e '\e[32;1m'$_newname' \e[m'
        read -p '[yes\no]' newnamecase
        case $newnamecase in
        [Yy]* )
                sed -i "3s/$v1/$_newname/g" config.xml
                echo -e '\e[32;1m >>>NOME ALTERADO<<< \e[m'
                break
        ;;
        [Nn]* )
                echo '...'
        ;;
        * ) echo -e '\e[31;1m>>>POR FAVOR ESCOLHA ENTRE yes OU no <<<\e[m';;
        esac
done

#Caso o valor que você queira alterar não esteja especificamente em uma tag, pode usar esse esquema
#Primeiramente o grep identifica os locais que possuem um determinado valor, especificamente na paste "config.xml"
#O valor é armazenado dentro de um arquivo que será criado com o nome testsed.txt
#Após isso armazeno o resultado dentro de um array, e identifico qual das casas esta com o valor que eu desejo.
#utilizo o sed para editar o valor, retirando os caracteres que não desejo, e guardo o resultado em outra pasta testeversion.txt
#Que em seguida volto a armazenar no array.
# e com o valor exato, consigo utilizar o sed para trocar especificamente o valor que quero.
#
echo "#######################################################"
grep "version" config.xml > testsed.txt
array=(${array[@]}`cat testsed.txt`)
echo ${array[5]} | sed -e 's/[version = " > <]//ig' > testeversion.txt
array[5]=`cat testeversion.txt`
echo "#######################################################"

while true; do
    echo -e "\e[33;1mA versão do app esta atualmente como ${array[5]}!\e[m"
    echo -e '\e[33;1mQual versão deseja atualizar ? \e[m'
    read _nometeste

    echo -e '\e[33;1mEsse é a version do app? \e[m'
    echo -e '\e[32;1m'$_nometeste' \e[m'
    read -p '[yes\no]' versionApp
    case $versionApp in
        [Yy]* )
            sed -i "2s/${array[5]}/$_nometeste/g" config.xml
            echo -e '\e[32;1mVersão Alterada\e[m'
            break
         ;;
        [Nn]* )
                echo '...'
        ;;
        * ) echo -e '\e[31;1m>>>POR FAVOR ESCOLHA ENTRE yes OU no <<<\e[m';;
    esac
done
