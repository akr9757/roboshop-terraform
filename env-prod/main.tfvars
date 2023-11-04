env              = "prod"
bastion_cidr     = ["172.31.25.45/32"]
monitor_cidr     = ["172.31.25.20/32"]
default_vpc_id   = "vpc-02f481ad4c25971d0"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rtid = "rtb-0eb5c7f12e35e3992"
kms_arn = "arn:aws:kms:us-east-1:726981961849:key/5816e42f-a81c-499f-b64a-cfe36d3610ba"
domain_name = "akrdevopsb72.online"
domain_id = "Z00062821VP7F1RRN67KU"


vpc = {
  main = {
    cidr_block = "10.100.0.0/16"
    subnets = {
      public = {
        name       = "public"
        cidr_block = ["10.100.0.0/24", "10.100.1.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
      web = {
        name       = "web"
        cidr_block = ["10.100.2.0/24", "10.100.3.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
      app = {
        name       = "app"
        cidr_block = ["10.100.4.0/24", "10.100.5.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
      db = {
        name       = "db"
        cidr_block = ["10.100.6.0/24", "10.100.7.0/24"]
        azs        = ["us-east-1a", "us-east-1b"]
      }
    }
  }
}

app = {
  frontend = {
    name             = "frontend"
    instance_type    = "t3.small"
    subnet_name      = "web"
    allow_app_cidr   = "public"
    app_port         = 80
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
    listener_priority = 1
    lb_type = "public"
    dns_name          = "www"
    parameters       = []
  }
  catalogue = {
    name             = "catalogue"
    instance_type    = "t3.small"
    subnet_name      = "app"
    allow_app_cidr   = "app"
    app_port         = 8080
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
    listener_priority = 1
    lb_type = "private"
    dns_name          = "prod"
    parameters       = ["docdb"]
  }
  user = {
    name             = "user"
    instance_type    = "t3.small"
    subnet_name      = "app"
    allow_app_cidr   = "app"
    app_port         = 8080
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
    listener_priority = 2
    lb_type = "private"
    dns_name          = "prod"
    parameters       = ["docdb"]
  }
  cart = {
    name             = "cart"
    instance_type    = "t3.small"
    subnet_name      = "app"
    allow_app_cidr   = "app"
    app_port         = 8080
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
    listener_priority = 3
    lb_type = "private"
    dns_name          = "prod"
    parameters       = []
  }
  payment = {
    name             = "payment"
    instance_type    = "t3.small"
    subnet_name      = "app"
    allow_app_cidr   = "app"
    app_port         = 8080
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
    listener_priority = 4
    lb_type = "private"
    dns_name          = "prod"
    parameters       = []
  }
  shipping = {
    name             = "shipping"
    instance_type    = "t3.medium"
    subnet_name      = "app"
    allow_app_cidr   = "app"
    app_port         = 8080
    desired_capacity = 2
    max_size         = 10
    min_size         = 2
    listener_priority = 5
    lb_type = "private"
    dns_name          = "prod"
    parameters       = ["rds"]
  }
}


docdb = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "4.0.0"
    instance_count = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "5.7.mysql_aurora.2.11.2"
    instance_count = 1
    instance_class = "db.t3.small"
  }
}

elasticache = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    engine_version = "6.x"
    replicas_per_node_group = 1
    num_node_groups = 1
    node_type = "cache.t3.micro"
  }
}

rabbitmq = {
  main = {
    subnet_name = "db"
    allow_db_cidr = "app"
    instance_type = "t3.small"
  }
}

alb = {
  public = {
    name = "public"
    subnet_name = "public"
    allow_alb_cidr = null
    internal = false
  }
  private = {
    name = "private"
    subnet_name = "app"
    allow_alb_cidr = "web"
    internal = true
  }
}