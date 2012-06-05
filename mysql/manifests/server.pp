class mysql::server {

  package { "mysql-server": 
    ensure => present,
    ;
  }

  service { "mysql": 
    ensure => running,
    enable => true,
    require => Package["mysql-server"],
    ;
  }

  exec { "set-mysql-password":
    unless => "mysqladmin -uroot -p$mysql_password status",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password $mysql_password",
    require => Service["mysql"],
  }
}