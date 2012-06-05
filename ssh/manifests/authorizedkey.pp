define ssh::authorizedkey ( $key, $comment, $type="ssh-dss", $user="root") {

       ssh::sshdir{$user:}

       exec { "echo $type $key $comment >> ~$user/.ssh/authorized_keys" :
          path => ['/bin', '/usr/bin' ],
          unless => "grep $key ~$user/.ssh/authorized_keys",
	  require => File["$user ssh"],
	  ;
       }
}