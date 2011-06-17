define nginx::redirect($ensure, $source, $destination) {
      file { "nginx-${source}":
          path => "/etc/nginx/sites-available/${source}",
          owner => root,
          group => root,
          mode => 644,
          content => template("nginx/redirect.conf"),
          notify => Service[nginx],
      }
	case $ensure {
      present: {
        File[ "nginx-${source}" ] { 
          require +> $require,
        }
   	# create symlink
      file { "/etc/nginx/sites-enabled/${source}":
               target => "/etc/nginx/sites-available/${source}",
		ensure => link,
	}
	}
      absent: {
       File["nginx-${source}"] { absent +> $absent,}
      }
     default: {
       fail("Invalid 'ensure'|'absent' value '$ensure' for nginx::redirect")
     }
   }
}

