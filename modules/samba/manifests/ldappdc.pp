class samba::ldappdc {

	include samba
	include systools::acl
	include ldap::provider

	$orgunits = ["Computers","Users","Groups"]
	
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
		content => template('samba/ldap-pdc-smb.conf.erb'),
		mode => 644,
		owner => "root",
		group => "root",
	}
	
	file { "/tmp/createOUs.ldif":
		owner => "root",
		group => "root",
		ensure => "present",
		require => Package["slapd"],
		content => template('samba/ldap-ou-structure.ldif.erb');
	}


	exec {"create_ldap_structure": 
		require => File["/tmp/createOUs.ldif"],
		command => "ldapadd -H ldap://localhost -x -D\"cn=admin,$ldap_basecontext\" -x -w $slapd_password -f /tmp/createOUs.ldif \
			&& touch /etc/ldap/ldap_structure_created",
		creates => '/etc/ldap/ldap_structure_created',
		path => ["/usr/bin", "/bin"];
	}

        exec {"store-ldap-admin-credentials":
		require => [File["/etc/samba/smb.conf"],
			    Package["samba"],
			    Package["slapd"],
			   ],
		command => "smbpasswd -w $slapd_password && touch /etc/samba/ldap-admin-creds-stored",
		creates => '/etc/samba/ldap-admin-creds-stored',
		path => ["/usr/bin", "/bin"];
	}	
	

}
