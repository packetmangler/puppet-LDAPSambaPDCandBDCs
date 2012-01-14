class samba::smbldap-tools {

	file {"/etc/smbldap-tools/smbldap_bind.conf":
		owner => 'root',
		group => 'root',
		mode => '600',
		content => template('samba/smbldap_bind.conf.erb'),
	}


	file {"/etc/smbldap-tools/smbldap.conf":
		owner => 'root',
		group => 'root',
		mode => '600',
		content => template('samba/smbldap.conf.erb'),
	}

}
