#!/bin/bash

# Habilitar el enrutamiento IP
#echo "1" > /proc/sys/net/ipv4/ip_forward

#Reset iptables
iptables -F

# Crear la cadena para el acceso completo
iptables -A FORWARD -i enp0s8 -o enp0s3 -s 192.168.68.0/24 -j ACCEPT
iptables -A FORWARD -i enp0s9 -o enp0s3 -s 192.168.68.0/24 -j ACCEPT


# Reglas de acceso al puerto 80 para las IP 192.168.68.5 a 192.168.68.10
for i in {5..10}; do
  iptables -A FORWARD -i enp0s8 -o enp0s3 -s 192.168.68.$i -p tcp --dport 80 -j ACCEPT
  iptables -A FORWARD -i enp0s9 -o enp0s3 -s 192.168.68.$i -p tcp --dport 80 -j ACCEPT
done

# Configurar NAT para el tráfico saliente
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# Guardar las reglas en un archivo
iptables-save > /etc/iptables/rules.v4

# Reiniciar el servicio de iptables
systemctl restart iptables

echo "Configuración completada."
