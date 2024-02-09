#init script
resource "ncloud_init_script" "create_init_pri" {
  count                       = length(var.subnet_pri_CIDR)
  name    = "tom-db-peristalsis-${count.index+1}"
  content = "#!/bin/bash \n sed -i 's/192.168.10.8/${var.server_db_CIDR[count.index]}/g' /usr/local/tomcat8.5/conf/context.xml \n sed -i 's/192.168.10.8/${var.server_db_CIDR[count.index]}/g'  /usr/local/tomcat8.5/webapps/ROOT/index.jsp \n systemctl restart tomcat"
}



#private server nic                        #안하면 acg안붙음
resource "ncloud_network_interface" "create_nic_pri" {
  count                       = length(var.subnet_pri_CIDR)
  name                  = "${var.pnoun}-pri-nic-${count.index+1}"
  subnet_no             = ncloud_subnet.create_pri_subnet[count.index].id
  private_ip            = "${var.server_pri_CIDR[count.index]}"
  access_control_groups = [ncloud_access_control_group.create_acg-pri.id]
}
#private server
resource "ncloud_server" "create_pri_sv" {
 count                      = length(var.subnet_pri_CIDR)
  subnet_no                 =  ncloud_subnet.create_pri_subnet[count.index].id
  name                      = "${var.pnoun}-pri-sv-${count.index+1}"
  member_server_image_no    = 22285014
  description               = "${var.pnoun}-pri-sv-${count.index+1} is best tip!!"
  init_script_no            = "${ncloud_init_script.create_init_pri[count.index].id}"
  login_key_name            = ncloud_login_key.create_key.key_name
  network_interface   {
    network_interface_no = ncloud_network_interface.create_nic_pri[count.index].id
    order = 0
  }
}

#pub nic
resource "ncloud_network_interface" "create_nic_pub" {
  count                       = length(var.subnet_pub_CIDR)
  name                  = "${var.pnoun}-pub-nic-${count.index+1}"
  subnet_no             = ncloud_subnet.create_pub_subnet[count.index].id
  access_control_groups = [ncloud_access_control_group.create_acg-pub.id]
}
#public server
resource "ncloud_server" "create_pub_sv" {
 count                     = length(var.subnet_pub_CIDR)
  subnet_no                =  ncloud_subnet.create_pub_subnet[count.index].id
  name                     = "${var.pnoun}-pub-sv-${count.index+1}"
  member_server_image_no   =  22233702
  description              = "${var.pnoun}-pub-sv-${count.index+1} is best tip!!"
  login_key_name           = ncloud_login_key.create_key.key_name
# init_script_no = "${ncloud_init_script.create_init.id}"
  network_interface   {
    network_interface_no = ncloud_network_interface.create_nic_pub[count.index].id
    order = 0
  }
}
#db server nic                        #안하면 acg안붙음
resource "ncloud_network_interface" "create_nic_db" {
  count                       = length(var.subnet_db_CIDR)
  name                  = "${var.pnoun}-db-nic-${count.index+1}"
  subnet_no             = ncloud_subnet.create_db_subnet[count.index].id
  private_ip            = "${var.server_db_CIDR[count.index]}"
  access_control_groups = [ncloud_access_control_group.create_acg-db.id]
}
#db server
resource "ncloud_server" "create_db_sv" {
 count                       = length(var.subnet_db_CIDR)
  subnet_no                 =  ncloud_subnet.create_db_subnet[count.index].id
  name                      = "${var.pnoun}-db-sv-${count.index+1}"
  member_server_image_no     = 22285162
  description                 = "${var.pnoun}-db-sv-${count.index+1} is best tip!!"
  login_key_name            = ncloud_login_key.create_key.key_name
  network_interface   {
    network_interface_no = ncloud_network_interface.create_nic_db[count.index].id
    order = 0
  }
}

#퍼블릿 ip
resource "ncloud_public_ip" "public-ip" {
  count                 =length(var.subnet_pub_CIDR)
  server_instance_no = ncloud_server.create_pub_sv[count.index].id
}
data "ncloud_root_password" "root_passwd_pub" {
  count                       = length(var.subnet_pri_CIDR)
  server_instance_no = ncloud_server.create_pub_sv[count.index].id
  private_key        = ncloud_login_key.create_key.private_key
}
data "ncloud_root_password" "root_passwd_pri" {
  count                       = length(var.subnet_pri_CIDR)
  server_instance_no = ncloud_server.create_pri_sv[count.index].id
  private_key        = ncloud_login_key.create_key.private_key
}
data "ncloud_root_password" "root_passwd_db" {
  count                       = length(var.subnet_db_CIDR)
  server_instance_no = ncloud_server.create_db_sv[count.index].id
  private_key        = ncloud_login_key.create_key.private_key
}


#LB Targetgroup
resource "ncloud_lb_target_group" "create_lb_tg" {
  name = "${var.pnoun}-lb-tag-web"
  vpc_no   = ncloud_vpc.create_vpc.id
  protocol = "HTTP"
  target_type = "VSVR"
  port        = 80
  description = "${var.pnoun}-lb-tag-web"
  health_check {
    protocol = "HTTP"
    http_method = "GET"
    port           = 80
    url_path       = "/"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
  algorithm_type = "RR"
}

#LB targetgorup attachment
resource "ncloud_lb_target_group_attachment" "create_lb_tg_att" {
  target_group_no = ncloud_lb_target_group.create_lb_tg.id
  target_no_list = [ncloud_server.create_pub_sv[0].id, ncloud_server.create_pub_sv[1].id]
}
#LB
resource "ncloud_lb" "create_lb" {
  name  =  "${var.pnoun}-lb-web"
  network_type = "PUBLIC"
  type = "APPLICATION"
  subnet_no_list = [ncloud_subnet.create_lb_subnet.id]
}

resource "ncloud_lb_listener" "listener" {
  load_balancer_no = ncloud_lb.create_lb.id
  protocol = "HTTP"
  port = 80
  target_group_no = ncloud_lb_target_group.create_lb_tg.id
}
