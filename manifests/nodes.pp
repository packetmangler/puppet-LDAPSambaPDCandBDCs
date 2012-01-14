node 'default' {
	$slapd_provider = "debianpdc.brianvmnat.com"
	$ldap_basecontext = 'dc=tyeewine,dc=com'
	$samba_workgroup = "tyeewine"
	$slapd_password = "ty33w1n3"
	$slapd_org = "tyeewine.com"
	include debconf
	include ssh
}

node 'debianpdc.brianvmnat.com' inherits default {
	include samba::ldappdc
	include gosa
	include freeradius
}
node 'debianbdc.brianvmnat.com' inherits default {
	include samba::ldapbdc
	include gosa::ldapschema
}

node 'sixosix' {
	$slapd_provider = "devbox.sixosix.com"
	$ldap_basecontext = 'dc=sixosix,dc=com'
	$samba_workgroup = "sixosix"
	$slapd_password = "ty33w1n3"
	$slapd_org = "sixosix.com"
	include debconf
	include ssh
}

node 'devbox.sixosix.com' inherits sixosix {
	include samba::ldappdc
	include gosa
}



node 'puppetmaster.sixosix.com' {
}

