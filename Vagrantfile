# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.env.enable              # enable the env plugin
  config.vm.box = "centos/7"     # box
  config.cache.scope = :machine  # tipo de cache(box e pacotes do SO)

  # Rede
  # --------------------------------
  # Cria uma rede privada, onde apenas a maquina hospedeira acessa a VM usando o IP específico
  config.vm.network "private_network", ip: "192.168.33.10"

  # Diretórios compartilhados
  # --------------------------------
  # Document root do Nginx
  config.vm.synced_folder "/home/alhaag/Projects/", "/var/www/html"
  # Configurações PHP e Nginx para que a script de provisionamento(always.sh) inclua no diretório de destino.
  config.vm.synced_folder ENV['NGINX_POLL'], "/home/vagrant/nginx.d"
  config.vm.synced_folder ENV['PHP_FMP_POLL'], "/home/vagrant/php-fpm.d"

  # Configurações do VirtualBox
  # --------------------------------
  config.vm.provider "virtualbox" do |vb|
    # Configurações de hardware
    vb.memory = "2048"
    vb.cpus = 1
  end

  # Provisionamento
  # --------------------------------
  # Script de provisionamento inicial.
  config.vm.provision "shell", path: "bootstrap.sh", env: {"MARIA_DB_USER" => ENV['MARIA_DB_USER'], "MARIA_DB_PASSWD" => ENV["MARIA_DB_PASSWD"]}
  # Scrip de checkup. Roda em todos os boots.
  config.vm.provision "shell", path: "always.sh", run: "always"
end
