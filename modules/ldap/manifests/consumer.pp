class ldap::consumer {

	include ldap::server

	file {"/tmp/consumer.ldif":
		owner => 'root',
		group => 'root',
		mode => 600,
		content => template("ldap/consumer.ldif.erb"),
	}




        exec {"ldapmodify-consumer":
                require => [File["/tmp/consumer.ldif"],
		            Package["slapd"],
			    Package["ldap-utils"],
			    ],
                command => "ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/consumer.ldif && touch /etc/ldap/ldap_consumer",
                creates => '/etc/ldap/ldap_consumer',
                path => ["/usr/bin", "/bin"];
        }


}
