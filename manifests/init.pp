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

    service{nginx:
        ensure => running,
        enable => true,
        hasstatus => true, 
        require => Package[nginx],
    }

    file{nginx.conf:
        path => '/etc/nginx/nginx.conf',
        source => [ "puppet://{$servername}/dist/nginx/nginx.conf-${fqdn}",
                    "puppet://{$servername}/dist/nginx/nginx.conf-default",
                    "puppet://{$servername}/nginx/nginx.conf-default" ],
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

    #conf.d file if needed
    # needs module gentoo
    #gentoo::etcconfd { nginx: require => "Package[nginx]", notify => "Service[nginx]"}
}
