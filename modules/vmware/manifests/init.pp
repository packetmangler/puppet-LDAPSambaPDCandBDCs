class vmware {
      package { "open-vm-tools":
        name => "open-vm-tools",
        ensure => present,
      }
}

