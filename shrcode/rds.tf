terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "replica"
  region = "us-west-2"
}

resource "aws_db_subnet_group" "sp-private-subgroup" {
  name       = "sp-rds-private-subnetgroup"
  subnet_ids = ["subnet-019f693594dc21c72", "subnet-0e4f837dd3b7bd173"]
  tags = {
    Name = "SP RDS private subnet group"
  }
}


resource "aws_db_instance" "sppostgres" {
  allocated_storage    = 20
  identifier           = "spsource"
  storage_type         = "gp3"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  db_name              = "sppostgres"
  username             = "apadmin"
  password             = "sppassword"
  db_subnet_group_name = aws_db_subnet_group.sp-private-subgroup.name
  skip_final_snapshot  = true
  # Optional Backup Settings
  backup_retention_period = 1
  backup_window           = "07:00-09:00"
  # Optional Performance Settings
  maintenance_window = "Mon:00:00-Mon:03:00"
  multi_az           = false
  tags = {
    Name = "sp-postgres-db"
  }
}

resource "aws_db_subnet_group" "sp-private-subgroup-uwest2" {
  name       = "sp-rds-private-subnetgroup-uwest2"
  subnet_ids = ["subnet-09ebc0fe24d190e4f", "subnet-0f1e113ed441ae1ec"]
  tags = {
    Name = "sp RDS private subnet group us-west-2"
  }
  provider = aws.replica
}

resource "aws_db_instance" "spreplicadb" {
 
  instance_class = "db.t3.micro"
  identifier  = "spcrr4"
  replicate_source_db = aws_db_instance.sppostgres.arn 
  db_subnet_group_name = aws_db_subnet_group.sp-private-subgroup-uwest2.name
 
  skip_final_snapshot = true
 
   lifecycle {
 
      ignore_changes = [snapshot_identifier]
 
   }
 
     provider = aws.replica
 
}