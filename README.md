Условия правильной работы playbook:

Так как контейнеры видят друг друга по ip-адресам, 
нужно правильно настроить сетевое взамодействие между узлами, на которых будут запущены docker-контейнеры.

Я проводил установку на ноды с ip-адресами ниже. Это содержание моего файла hosts. 
192.168.0.21 mongo-master
192.168.0.22 mongo-slave-1
192.168.0.23 mongo-slave-2

ВНИМАНИЕ! Всем нодам необходимо прописать коректный hostname! Иначе ничегоработать не будет.

Вы должны использовать свои адреса. ВНИМАНИЕ! Если будете использовать свои адреса, то их так же необходимо будет переопределить 
в скрипте инициализации для репликации. Скрипт находится в по адресу https://github.com/Denissa89/mongodbclusterV.2.0/blob/master/roles/mongodb/templates/init_cluster.sh

Подготовка и запуск playbook:
apt install ansible git
git clone https://github.com/Denissa89/mongodbclusterV.2.0.git

cp -r mongodbclusterV.2.0/ /etc/ansible
rm -rf /etc/ansible/*
ssh-keygen

ssh-copy-id root@your_ip_address

Нужно добавить адреса ваших нод в файл hosts. Мой файл выглядит так:
[mongodb]
192.168.0.21 ansible_user=root
192.168.0.22 ansible_user=root
192.168.0.23 ansible_user=root

Запускаем playbook:
ansible-playbook mongodb_setup.yml

Для подключения используем:
logint: support
passwd: 110801
