class ldap {

	
	package { "ldap-utils":

	ensure => "present",

	}
	
	package { "libnss-ldap":
		ensure => "present",
		require => [ File["/tmp/libnss-ldap.seed"],
		    	     Package["slapd"],
		  	   ],
		responsefile => "/tmp/libnss-ldap.seed",
	}

	file {"/tmp/libnss-ldap.seed":
		content => template("ldap/libnss-ldap.seed.erb"),
		owner => "root",
		group => "root",
		mode => "400",
		require => Package["debconf-utils"];
	}

	file {"/etc/nsswitch.conf":
		source => "puppet:///ldap/$operatingsystem/nsswitch.conf",
		ensure => "present",
		require => Package["libnss-ldap"],
		owner => "root",
		group => "root",
		mode => "644",
	}

	file {"/etc/nscd.conf":
		source => "puppet:///ldap/$operatingsystem/nscd.conf",
		ensure => "present",
		require => Package["libnss-ldap"],
		owner => "root",
		group => "root",
		mode => "644",
	}
			
	service {"nscd":
		subscribe => [ File["/etc/nsswitch.conf"],
			       File["/etc/nscd.conf"],
			     ],
	}

}
