#!/usr/bin/env bash

###
#
# always.sh - Executada a cada boot da VM.
#
# Realiza ajustes e configurações que não são mantidas no reboot da VM.
# Pode ser utilizada também para verificação de processos e configurações.
#
# @author André Luiz Haag <andreluizhaag@gmail.com>
#
###

#
# SELinux
# --------------------------------
# Necessário para que o Nginx posso acessar os arquivos em /var/www
sudo setenforce Permissive

#
# Configurações de sites (nginx e php-fpm)
# --------------------------------
sudo rm -rf /etc/nginx/conf.d/*.conf                    # Limpa
sudo cp -r /home/vagrant/nginx.d/** /etc/nginx/conf.d/  # Copia atuais
sudo rm -rf /etc/php-fpm.d/*.conf                       # Limpa
sudo cp -r /home/vagrant/php-fpm.d/** /etc/php-fpm.d/   # Copia atuais
# Reinicia processos
sudo systemctl restart php-fpm.service
sudo systemctl restart nginx.service

#
# Verificações de integridade
# --------------------------------
# Checa o Nginx
if !(pgrep nginx > /dev/null); then
    echo "[ nok ] Nginx não está sendo executado."
else
    echo "[ ok ] Nginx pronto."
fi

# Checa o PHP-FPM
if !(pgrep php-fpm > /dev/null); then
    echo "[ nok ] PHP-FPM não está sendo executado."
else
    echo "[ ok ] PHP-FPM pronto."
fi

# Checa o MariaDB
if !(pgrep mysql > /dev/null); then
    echo "[ nok ] MariaDB não está sendo executado."
else
    echo "[ ok ] MariaDB pronto."
fi
