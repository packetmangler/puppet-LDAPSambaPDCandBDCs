class gosa::ldapschema {

	package {"gosa-schema":
		ensure => "present",
		require => Package['slapd'],
		}

	file {"/etc/ldap/schema/gosa/gosystem.ldif":
		source => "puppet:///gosa/$operatingsystem/gosystem.ldif",
		mode => 644,
		owner => "root",
		group => "root",
		require => Package[gosa-schema],
	}
	


	file {"/etc/ldap/schema/gosa/gofon.ldif":
		source => "puppet:///gosa/$operatingsystem/gofon.ldif",
		mode => 644,
		owner => "root",
		group => "root",
		require => Package[gosa-schema],
	}


	file {"/etc/ldap/schema/gosa/gofax.ldif":
		source => "puppet:///gosa/$operatingsystem/gofax.ldif",
		mode => 644,
		owner => "root",
		group => "root",
		require => Package[gosa-schema],
	}

	file {"/etc/ldap/schema/gosa/goto.ldif":
		source => "puppet:///gosa/$operatingsystem/goto.ldif",
		mode => 644,
		owner => "root",
		group => "root",
		require => Package[gosa-schema],
	}

	file {"/etc/ldap/schema/gosa/goserver.ldif":
		source => "puppet:///gosa/$operatingsystem/goserver.ldif",
		mode => 644,
		owner => "root",
		group => "root",
		require => Package[gosa-schema],
	}

	file {"/etc/ldap/schema/gosa/gosa-samba3.ldif":
		source => "puppet:///gosa/$operatingsystem/gosa-samba3.ldif",
		mode => 644,
		owner => "root",
		group => "root",
		require => Package[gosa-schema],
	}

        exec {"ldapadd-gosystem.ldif":
                command =>'/usr/bin/ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/gosa/gosystem.ldif',
                creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={5}gosystem.ldif',
                require => [ Package["slapd"],
                             Package["ldap-utils"],
                             Package["gosa-schema"],
                             File["/etc/ldap/schema/gosa/gosystem.ldif"],
                             Exec["extend-ldapschema-samba"],
                           ]
        }

        exec {"ldapadd-gofon.ldif":
                command =>'/usr/bin/ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/gosa/gofon.ldif',
                creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={6}gofon.ldif',
                require => [ Exec["ldapadd-gosystem.ldif"],
                             File["/etc/ldap/schema/gosa/gofon.ldif"],
                           ]
        }

        exec {"ldapadd-gofax.ldif":
                command =>'/usr/bin/ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/gosa/gofax.ldif',
                creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={7}gofax.ldif',
                require => [ Exec["ldapadd-gofon.ldif"],
                             File["/etc/ldap/schema/gosa/gofax.ldif"],
                           ]
        }

        exec {"ldapadd-goto.ldif":
                command =>'/usr/bin/ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/gosa/goto.ldif',
                creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={8}goto.ldif',
                require => [ Exec["ldapadd-gofax.ldif"],
                             File["/etc/ldap/schema/gosa/goto.ldif"],
                           ]

        }

        exec {"ldapadd-goserver.ldif":
                command =>'/usr/bin/ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/gosa/goserver.ldif',
                creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={9}goserver.ldif',
                require => [ Exec["ldapadd-goto.ldif"],
                             File["/etc/ldap/schema/gosa/goserver.ldif"],
                           ]
        }

        exec {"ldapadd-gosa-samba3.ldif":
                command =>'/usr/bin/ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/gosa/gosa-samba3.ldif',
                creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={10}gosa-samba3.ldif',
                require => [ Exec["ldapadd-goserver.ldif"],
                             File["/etc/ldap/schema/gosa/gosa-samba3.ldif"],
                           ]
        }


}
