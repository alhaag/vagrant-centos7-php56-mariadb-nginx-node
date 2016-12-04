# CentOS 7 developer environment

## Funcionalidades
Prove ambiente de desenvolvimento em CentOS 7 com as seguintes aplicações:
 * PHP-FPM 5.6.x
 * NodeJS e NPM
   * gulp
   * bower
 * Nginx
 * MariaDB
 * GIT
 * vim

Para um mair desempenho a box do Vagrant e pacotes instalados durante o provisionamento são armazenados em cache.

## Requisitos
 * Virtual Box 5 ou maior
 * Vagrant 1.7.4 ou maior
 * Plugins do vagrant:
  * vagrant-vbguest
  * vagrant-env

Exemplo para instalação vagrant e suas dependências no Ubuntu:
```
$ sudo apt-get install vagrant
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-env
$ vagrant plugin install vagrant-cachier
```

## Utilização
Copiar o arquivo **.env.example** para **.env** e alterar as variáveis conforme necessidade.

| Variável        | Descrição             |
| --------------- |:---------------------:|
| NGINX_POLL      | Díretório que pussui arquivos de configurção de virtualhosts(sites) do nginx |
| PHP_FMP_POLL    | Díretório que pussui arquivos de configurção de pool de sites do PHP-FPM |
| MARIA_DB_USER   | Usuário padrão que deverá ser criado no MariaDB(não utilizar o root) |
| MARIA_DB_PASSWD | Senha do usuário do MariaDB |

Importante: o arquivo **.env.example** não deve ser editado.

Comandos básicos do Vagrant (executar no diretório onde está localizado o arquivo Vagrantfile):
```
$ vagrant up        # provisiona a VM
$ vagrant ssh       # acessa o terminal da VM por ssh
<Ctrl> + d ou exit  # abandona o terminal
$ vagrant reload    # reinicia a VM e carega novas configurações
$ vagrant suspend   # suspende a VM e mantém o estado
$ vagrant resume    # retoma uma VM suspensa
$ vagrant halt      # desliga a VM e mantem o estado
$ vagrant destroy   # elimina a VM (irreversível)
```
