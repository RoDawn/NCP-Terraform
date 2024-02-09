// VPC 이름
variable "pnoun" {
  type = string
  default = "proper-noun"
}
// 키 이름
resource "ncloud_login_key" "create_key" {
  key_name = "${var.pnoun}-key-1"
}
resource "local_file" "ncp_pem" {
  filename = "${var.pnoun}-1.pem"
  content = ncloud_login_key.create_key.private_key
}
// VPC CIDR
variable "vpc_cidr_block" {
  type = string
  default = "10.2.0.0/16"
}
// Subnet을 생성할 Zone 선택(ex:KR-1,KR-2...)
variable "zone" {
  type = string
  default="KR-2"
}
// Subnet_pub 사용 대역
variable "subnet_pub_CIDR" {
  type = list
  default= ["10.2.11.0/24", "10.2.12.0/24"]
}
// Subnet_pri 사용 대역
variable "subnet_pri_CIDR" {
  type = list
  default= ["10.2.21.0/24", "10.2.22.0/24"]
}
// Subnet_db 사용 대역
variable "subnet_db_CIDR" {
  type = list
  default= ["10.2.31.0/24", "10.2.32.0/24"]
}
// Server_pri 사용 대역
variable "server_pri_CIDR" {
  type = list
  default= ["10.2.21.6", "10.2.22.7"]
}
// Server_db 사용 대역
variable "server_db_CIDR" {
  type = list
  default= ["10.2.31.6", "10.2.32.7"]
}
// Prometheus_ip
variable "prome_CIDR" {
  type = string
  default = "10.123.0.0/16"
}
// VPC 생성
resource "ncloud_vpc" "create_vpc" {
    name = "${var.pnoun}-vpc"
    ipv4_cidr_block = var.vpc_cidr_block
}
resource "ncloud_vpc_peering" "create_vpc_peering" {
  name          = "vpc-peering-pro-ip"
  source_vpc_no = ncloud_vpc.create_vpc.id
  target_vpc_no = 54277
}
resource "ncloud_route" "create_peer_pri" {
  route_table_no         =  ncloud_vpc.create_vpc.default_private_route_table_no
  destination_cidr_block = "10.123.0.0/16"
  target_type            = "VPCPEERING"  // NATGW (NAT Gateway) | VPCPEERING (VPC Peering) | VGW (Virtual Private Gateway).
  target_name            = ncloud_vpc_peering.create_vpc_peering.name
  target_no              = ncloud_vpc_peering.create_vpc_peering.id
}
// NATGW 여부
variable "natgw_chk" {
  type = bool
  default = false
}
// Route table ID
variable "route_table_no" {
  type = string
  default = ""
}

// NACL 생성
resource "ncloud_network_acl" "create_nacl" {
   vpc_no      = ncloud_vpc.create_vpc.id
   name        = "${var.pnoun}-nacl"
   description = "${var.pnoun}용 nacl"
 }
// Subnet 생성
resource "ncloud_subnet" "create_pub_subnet" {
    count = length(var.subnet_pub_CIDR)
  vpc_no = ncloud_vpc.create_vpc.id
  subnet = "${var.subnet_pub_CIDR[count.index]}"
  zone = var.zone
  network_acl_no = ncloud_network_acl.create_nacl.network_acl_no
  subnet_type = "PUBLIC"
// PUBLIC(Public) | PRIVATE(Private)
  name = "${var.pnoun}-pub-sub-${count.index+1}"
  usage_type = "GEN"
}
resource "ncloud_subnet" "create_pri_subnet" {
    count = length(var.subnet_pri_CIDR)
  vpc_no = ncloud_vpc.create_vpc.id
  subnet = "${var.subnet_pri_CIDR[count.index]}"
  zone = var.zone
  network_acl_no = ncloud_network_acl.create_nacl.network_acl_no
  subnet_type = "PRIVATE"
// PUBLIC(Public) | PRIVATE(Private)
  name = "${var.pnoun}-pri-sub-${count.index+1}"
  usage_type = "GEN"
}
resource "ncloud_subnet" "create_db_subnet" {
    count = length(var.subnet_db_CIDR)
  vpc_no = ncloud_vpc.create_vpc.id
  subnet = "${var.subnet_db_CIDR[count.index]}"
  zone = var.zone
  network_acl_no = ncloud_network_acl.create_nacl.network_acl_no
  subnet_type = "PRIVATE"
// PUBLIC(Public) | PRIVATE(Private)
  name = "${var.pnoun}-db-sub-${count.index+1}"
  usage_type = "GEN"
}
resource "ncloud_subnet" "create_lb_subnet" {
  vpc_no         = ncloud_vpc.create_vpc.id
  subnet         = "10.2.101.0/24"
  zone           = var.zone
  network_acl_no = ncloud_network_acl.create_nacl.network_acl_no
  subnet_type    = "PUBLIC" // PUBLIC(Public) | PRIVATE(Private)
  // below fields is optional
  name           = "${var.pnoun}-pub-sub-lb"
  usage_type     = "LOADB"    // GEN(General) | LOADB(For load balancer)
}
