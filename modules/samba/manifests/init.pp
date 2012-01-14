class samba {

	package { samba: ensure => latest }


	service {"smbd":
		name => $operatingsystem ? {
			Debian => "samba",
			Ubuntu => "smbd",
		},
		enable => "true",
		ensure => "running",
		subscribe => [ Package["samba"],
		    	       File["/etc/samba/smb.conf"],
		     	     ]
	}
	if $operatingsytem == 'Ubuntu' {
		service {"nmbd":
			enable => "true",
			ensure => "running",
			subscribe => [ Package["samba"],
		    		       File["/etc/samba/smb.conf"],
		     		     ]
		}
	}
}
