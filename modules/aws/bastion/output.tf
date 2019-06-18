output "bastion" {
  value = {
    "bastion_security_id" = aws_security_group.bastion.id
    "key_pair_id"         = aws_key_pair.ssh_key_pair.id
  }
}
