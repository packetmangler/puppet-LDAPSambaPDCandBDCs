class ldap::provider {

	include ldap::server

	file {"/tmp/provider.ldif":
		owner => 'root',
		group => 'root',
		mode => 600,
		content => template("ldap/provider.ldif.erb"),
	}

	file {"/var/lib/ldap/accesslog":
		owner => 'openldap',
		group => 'openldap',
		ensure => "directory",
		require => Package["slapd"],
	}	

	
	exec {"copy_dbconfig_accesslog":
                require => [File["/tmp/provider.ldif"],
			    File["/var/lib/ldap/accesslog"],
		            Package["slapd"],
			    Package["ldap-utils"],
			    ],
		command => "cp /var/lib/ldap/DB_CONFIG /var/lib/ldap/accesslog/ \
			   && touch /etc/ldap/db_config-copied",
		creates => '/etc/ldap/db_config-copied',
                path => ["/usr/bin", "/bin"];
	}


	file {"/var/lib/ldap/accesslog/DB_CONFIG":
		owner => 'openldap',
		group => 'openldap',
		require => Exec["copy_dbconfig_accesslog"],
	}

        exec {"ldapmodify-provider":
                require => [File["/tmp/provider.ldif"],
		            Package["slapd"],
			    Package["ldap-utils"],
			    File["/var/lib/ldap/accesslog/DB_CONFIG"],
			    ],
                command => "ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/provider.ldif && touch /etc/ldap/ldap_provider",
                creates => '/etc/ldap/ldap_provider',
                path => ["/usr/bin", "/bin"];
        }


}
