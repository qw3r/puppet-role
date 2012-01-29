class role::default {
	include apt
	include bash
	include common
	include dpkg
	include monit
	include motd
	include resolv
	include screen
	include sudo
	include vim
}

class role::extern {
	include fail2ban
	monit::service { "fail2ban": }
}

class role::server {
	include apticron

	include icinga
	if $::lsbdistcodename == "lenny" {
		monit::service { "nrpe.lenny": }
	} else {
		monit::service { "nrpe.common": }
		sudo::service { "icinga": }
	}

	include metche

	include ntp
	icinga::service::services { "ntp":
		command => "check_ntp_time",
	}
	monit::service { "ntp": }

	include puppet
	icinga::service::services { "puppet":
		command => "nrpe_check_puppet!2700!3600",
	}
	monit::service { "puppet.agent": }
}

# vim: tabstop=3
