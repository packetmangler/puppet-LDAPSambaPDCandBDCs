class samba::ldapbdc {

	include samba
	include systools::acl
	include ldap::consumer

	
	package {"smbldap-tools":
		ensure => "latest",
	}
	
	file { "/etc/ldap/schema/samba.ldif":
		owner => "root",
		group => "root",
		ensure => "present",
		require => Package["slapd"],
		source => "puppet:///samba/$operatingsystem/samba.ldif",
	}

	exec {"extend-ldapschema-samba": 
		command => "ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/samba.ldif",
		require => File["/etc/ldap/schema/samba.ldif"],
		creates => '/etc/ldap/slapd.d/cn=config/cn=schema/cn={4}samba.ldif',
		path => ["/usr/bin", "/bin"];
	}
	
	file { "/etc/samba/smb.conf":
		require => Package["samba"],
		content => template('samba/ldap-bdc-smb.conf.erb'),
		mode => 644,
		owner => "root",
		group => "root",
	}
	


        exec {"store-ldap-admin-credentials":
		require => [File["/etc/samba/smb.conf"],
			    Package["slapd"],
			   ],
		command => "smbpasswd -w $slapd_password && touch /etc/samba/ldap-admin-creds-stored",
		creates => '/etc/samba/ldap-admin-creds-stored',
		path => ["/usr/bin", "/bin"];
	}	
	

}
