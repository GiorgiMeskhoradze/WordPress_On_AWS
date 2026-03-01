resource "aws_efs_file_system" "efs_file" {
  encrypted = true

  tags = {
    "Name" = "wordpress-efs" 
  }
}

resource "aws_efs_mount_target" "efs_file_mounted" {
  for_each = var.private_subnet_ids
  file_system_id = aws_efs_file_system.efs_file.id
  subnet_id = each.value
  security_groups = [var.efs_sg_group_id]
}