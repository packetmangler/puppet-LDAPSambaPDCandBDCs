class systools::acl {

        package {"acl":
        ensure => "installed",
        }

        mount {"/":
        options => "acl,errors=remount-ro",
        ensure => "present",
        require => Package["acl"],
        }

}
