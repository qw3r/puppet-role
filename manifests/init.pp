class role::default {
	include apt
	include bash
	include common
	include dpkg
	include hosts
	include monit
	include motd
	include resolv
	include screen
	include sudo
	include vim
}

class role::extern {
	#include fail2ban
	#monit::service { "fail2ban": }
}

class role::server {
	include nagios
	monit::service { "nrpe-common": }
	sudo::service { "nagios": }

	include metche

	include ntp
	nagios::service::services { "ntp":
		command => "check_ntp_time",
	}
	monit::service { "ntp": }

	include postfix
	icinga::service::services { "mailq":
		command => "nrpe_check_mailq!5!10",
		group   => "mailq",
	}
	monit::service { "postfix": }

	include puppet
	nagios::service::services { "puppet":
		command => "nrpe_check_puppet!2700!3600",
	}
	monit::service { "puppet-agent": }

	include ssh
	nagios::service::services { "ssh":
		command => "check_ssh",
	}
	monit::service { "ssh": }
}

