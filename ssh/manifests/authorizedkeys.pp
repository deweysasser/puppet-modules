# TODO:  1) change the manage script to be a virtual resource
#        2) Change the script to manage independent files in a ~/.ssh/puppet-managed directory
#        3) Use the above for both this and the individual authorized keys

define ssh::authorizedkeys( $source, $forbid=undef ) {
       ssh::sshdir{ $title : }

       if $title == "root" {
          $homedir="/root"
       } else {
          $homedir="/home/$title"
       }

       file { 
          "$homedir/.ssh/puppet-required-keys.txt":
       	    ensure => file,
	    source => $source,
	    owner => $title,
	    mode => 700,
	    ;
	   "$homedir/.ssh/puppet-manage":
	    ensure => file,
	    source => "puppet:///modules/ssh/puppet-manage",
	    mode => 755,
	    ;
       }

       if $forbid {
          file { 
             "$homedir/.ssh/puppet-forbidden-keys.txt":
       	      ensure => file,
	      source => $forbid,
	      owner => $title,
	      mode => 700,
	      #notify => Exec["puppet-manage $user"],
	      notify => Exec["$homedir/.ssh/puppet-manage -file $homedir/.ssh/authorized_keys -require $homedir/.ssh/puppet-required-keys.txt -forbid $homedir/.ssh/puppet-forbidden-keys.txt"],
	      ;
	   }
       }

       exec { "$homedir/.ssh/puppet-manage -file $homedir/.ssh/authorized_keys -require $homedir/.ssh/puppet-required-keys.txt -forbid $homedir/.ssh/puppet-forbidden-keys.txt":
       # I think this alias should work, but apparantly it doesn't
#           alias => "puppet-manage $user",
           refreshonly=>true,
	   require=> File["$homedir/.ssh/puppet-manage"],
	   subscribe => File["$homedir/.ssh/puppet-required-keys.txt"],
	   ;
       }
}