class freeradius {

	package {"freeradius":
	   ensure => "installed",
	}
	package {"freeradius-ldap":
	   ensure => "installed",
	}

	file {"radldap-conf":
	   path => "/etc/freeradius/modules/ldap",
	   owner => "root",
	   group => "root",
	   mode => 600,
 	   content => template("freeradius/ldap.erb"),
	}
	
	file {"raddefault-site":
	   path => "/etc/freeradius/sites-available/default",
	   owner => "root",
	   group => "root",
 	   source => "puppet:///freeradius/default",
	}
	


	service {"freeradius":
	   subscribe => [ File["radldap-conf"],
		          File["raddefault-site"] ],
	}
}
