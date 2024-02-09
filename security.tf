#라우트 테이블 pri
#resource "ncloud_route_table" "create_route_table_pri" {
#  vpc_no                = ncloud_vpc.create_vpc.id  
#  supported_subnet_type = "PRIVATE" // PUBLIC | PRIVATE
#  // below fields is optional
#  name                  = "${var.pnoun}-pri-route-table"
#  description           = "${var.pnoun}-vpc-private-route-table"
#}
#resource "ncloud_route_table_association" "route_table_ass_pri" {
#    count                 = length(var.subnet_pri_CIDR)
#    route_table_no        = ncloud_route_table.create_route_table_pri.id
#    subnet_no             = ncloud_subnet.create_pri_subnet[count.index].id
#}
#acg생성
resource "ncloud_access_control_group" "create_acg-pub" {
   name       = "${var.pnoun}-acg-pub"
  description = "${var.pnoun}-acg-pub"
  vpc_no      = ncloud_vpc.create_vpc.id
}
#acg 룰
resource "ncloud_access_control_group_rule" "create_acg-pub-rule" {
  access_control_group_no = ncloud_access_control_group.create_acg-pub.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "accept 22 port"
  }

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    description = "accept 80 port"
  }

 inbound {
    protocol    = "TCP"
    ip_block    = "${var.prome_CIDR}"
    port_range  = "9000-10000"
    description = "accept 9000-10000 port"
  }


  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0" 
    port_range  = "1-65535"
    description = "accept 1-65535 port"
  }

  outbound {
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0" 
    port_range  = "1-65535"
    description = "accept 1-65535 port"
  }
}
#acg 프라리빗
resource "ncloud_access_control_group" "create_acg-pri" {
   name       = "${var.pnoun}-acg-pri"
  description = "${var.pnoun}-acg-pri"
  vpc_no      = ncloud_vpc.create_vpc.id
}
resource "ncloud_access_control_group_rule" "create_acg-rule" {
  access_control_group_no = ncloud_access_control_group.create_acg-pri.id

  inbound {
    protocol    = "TCP"
    ip_block    = "${var.vpc_cidr_block}"
    port_range  = "22"
    description = "accept 22 port"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "${var.vpc_cidr_block}"
    port_range  = "8080"
    description = "accept 80 port"
  }
 inbound {
    protocol    = "TCP"
    ip_block    = "${var.prome_CIDR}"
    port_range  = "9000-10000"
    description = "accept 9000-10000 port"
  }

  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0" 
    port_range  = "1-65535"
    description = "accept 1-65535 port"
  }
}
#acg db
resource "ncloud_access_control_group" "create_acg-db" {
   name       = "${var.pnoun}-acg-db"
  description = "${var.pnoun}-acg-db"
  vpc_no      = ncloud_vpc.create_vpc.id
}
resource "ncloud_access_control_group_rule" "create_acg-rule-db" {
  access_control_group_no = ncloud_access_control_group.create_acg-db.id

  inbound {
    protocol    = "TCP"
    ip_block    = "${var.vpc_cidr_block}"
    port_range  = "22"
    description = "accept 22 port"
  }

  inbound {
    protocol    = "TCP"
    ip_block    = "${var.vpc_cidr_block}"
    port_range  = "3306"
    description = "accept 33060 port"
  }
 inbound {
    protocol    = "TCP"
    ip_block    = "${var.prome_CIDR}"
    port_range  = "9000-10000"
    description = "accept 9000-10000 port"
  }

  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0" 
    port_range  = "1-65535"
    description = "accept 1-65535 port"
  }
}
