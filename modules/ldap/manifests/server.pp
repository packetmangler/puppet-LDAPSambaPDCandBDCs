class ldap::server {

	include ldap
	Package['debconf-utils'] -> File['/tmp/slapd.preseed'] -> Package['slapd']

	file { "/tmp/slapd.preseed":
		owner => "root",
		group => "root",
		mode => 600,
		content => template("ldap/slapd.preseed.erb"),
		require => Package["debconf-utils"],
	}

	
	package { "slapd":
	ensure => present,
	responsefile => "/tmp/slapd.preseed",
	require => [ File["/tmp/slapd.preseed"],
		     Package["ldap-utils"],
		     Package["debconf-utils"],
		   ]
	}


}
