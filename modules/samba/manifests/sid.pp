class samba::sid {

	file { "/tmp/SID.txt":
		owner => 'root',
		group => "root",
		mode => 644,
		content => template("samba/sid.erb"),
	}

}
