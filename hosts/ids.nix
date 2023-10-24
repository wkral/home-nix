{
  livingroom = {
    ssh.wkral = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGfvCLm5qbfNligZ/AKOydr1OovDaTdje4NBwnJr5EAc wkral@livingroom";
    wg-pubkey = "QlckeDNPkP5JhfMI13ginVxnDtg+mUE2HH/0ex7qu2Y=";
    wg-ip = "10.100.0.1/32";
  };
  framework = {
    ssh.wkral = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxgITfJE8nrE1JkTn7U+4otLffeJ4nMVk/CoOORoG5W wkral@framework";
    wg-pubkey = "dRzOQaG4GAmYjs2ZsNeO+ldyA6AxBLj2GpOPHvUM1BM=";
    wg-ip = "10.100.0.3/32";
  };
  deck = {
    ssh.wkral = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOe6prMbcOivp+6bgN/QZixvljrxRMU9gh0l2TJL2uTt wkral@deck";
    wg-pubkey = "TGSPCrfg+jf5dcnXs1+z9/LYE6f7iHQ1AU9ubt7CAEs=";
    wg-ip = "10.100.0.2/32";
  };
  work-vm.ssh.wkral = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU/4DYvPYGqa8/jmoDo8rC1Yn3uEVfbTwXPhzZh8ZHX";
  macbook.ssh.wkral = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSsYbuCFzk+qWYhj1C+bPkcfUKQQw9J51bt6FszVZaD";

  wireguard-endpoint = "69.172.157.122:51820";
}
