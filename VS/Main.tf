resource "local_file" "newfile" {
  filename = "file1.txt"
  content  = "this is my first file content"
}
resource "local_file" "explicitdependency" {
    filename = "file1_explicit.txt"
    content = " Password file is ${local_file.NewPassword.filename}"
    depends_on = [
        local_file.NewPassword
    ]
}
resource "local_file" "NewPassword"{
    filename = "Password_file.txt"
    content = "My new password is ${random_password.PasswordGen.result}"
}
resource "random_password" "PasswordGen" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}



# Terraform Variables https://upcloud.com/resources/tutorials/terraform-variables

variable "model" {
  type = string
  default = "01000000-0000-4000-8000-000030080200"
}

variable "users" {
  type    = list
  default = ["root", "user1", "user2"]
}

variable "set_password" {
  default = false
}

resource "local_file" "rootuser" {
  filename = var.users[0]
  content  = "password set ${var.set_password}"
}

#  terraform apply -var="set_password=true"

#  export TF_VAR_set_password="SECRET"  

#  Loading variables automatically using terraform.tfvars

#  terraform apply -var-file="custom.tfvars"

output "ModelNo" {
    value = var.model
}

# terraform output ModelNo

resource "local_file" "datasrc" {
  filename = "file2.txt"
  content  = data.local_file.sourcetext.content
}


#Meta Arguments
# depends_on
# count
# length
# for_each