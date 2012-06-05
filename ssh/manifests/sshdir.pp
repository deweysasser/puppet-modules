define ssh::sshdir {

       if $title == "root" {
          $homedir="/root"
       } else {
          $homedir="/home/$title"
       }

       file { "$homedir/.ssh":
            alias => "$title ssh",
       	    ensure => directory,
	    mode => 700,
	    ;
       }
}