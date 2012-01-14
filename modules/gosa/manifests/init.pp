class gosa {
	
	package { "gosa-plugin-samba":

		ensure => "latest",
		require => [ Package["debconf-utils"],
			     Package["slapd"],
			     Package["ldap-utils"],
			     Package["samba"],
			   ]
	}

	include gosa::ldapschema






}
