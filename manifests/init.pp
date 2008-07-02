# modules/nginx/manifests/init.pp - manage nginx stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

# modules_dir { "nginx": }

class nginx {
    case $operatingsystem {
        gentoo: { include nginx::gentoo }
        default: { include nginx::base }
    }
}

class nginx::base {
    package{'nginx':
        ensure => installed,
    }

    service{'nginx':
        ensure => running,
        enable => true,
        hasstatus => false, 
        require => Package[nginx],
    }

    file{nginx_config:
        path => '/etc/nginx/nginx.conf',
        source => [ "puppet://$server/files/nginx/${fqdn}/nginx.conf",
                    "puppet://$server/files/nginx/nginx.conf",
                    "puppet://$server/nginx/nginx.conf" ],
        owner => root,
        group => 0,
        mode => 0644,
        require => Package[nginx],
        notify => Service[nginx],
    }
}

class nginx::gentoo inherits nginx::base {
    Package[nginx]{
        category => 'www-servers',
    }
}
