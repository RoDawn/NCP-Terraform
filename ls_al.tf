#아파치 톰캣 연동
resource "null_resource" "apa-tom" {
  count = length(var.subnet_pri_CIDR)
  connection {
    type     = "ssh"
    host     = ncloud_public_ip.public-ip[count.index].public_ip
    user     = "root"
    port     = "22"
    password = data.ncloud_root_password.root_passwd_pub[count.index].root_password
 }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/tier3-pri-nlb-22193284-4c9e633ee83b.kr.lb.naverncp.com/${ncloud_network_interface.create_nic_pri[count.index].private_ip}/g' /usr/local/apache/conf/httpd.conf",
      "sleep 2",
      "sed -i 's/tier3-pri-nlb-22193284-4c9e633ee83b.kr.lb.naverncp.com/${ncloud_network_interface.create_nic_pri[count.index].private_ip}/g' /usr/local/apache/conf/httpd.conf",
   "sleep 2",
       "systemctl restart apache",
]
  }

  depends_on = [
    ncloud_server.create_pri_sv,
    ncloud_public_ip.public-ip,
  ]
}
