variable access_key {
  default = "7738E1E3E867D659C97D"
}           #이렇게 적으면 안되요

variable secret_key {
  default = "2EC91AE7681E2BAD6723011E314B018D1A1C1F23"
}           #삭제  #delete  #remove

provider "ncloud" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  region = "KR"
  site = "public"
  support_vpc = "true"
}
