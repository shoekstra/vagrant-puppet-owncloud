case $::osfamily {
  'Debian': {
    $ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
    $ssl_key  = '/etc/ssl/private/ssl-cert-snakeoil.key'
  }
  'RedHat': {
    $ssl_cert = '/etc/pki/tls/certs/localhost.crt'
    $ssl_key  = '/etc/pki/tls/private/localhost.key'
  }
}

class { '::mysql::server':
  override_options => {
    'mysqld' => { 'bind-address' => $::ipaddress }
  },
  restart       => true,
  root_password => 't0ps3cr3t',
  before        => Class['::owncloud']
}

class { '::owncloud':
  ssl      => true,
  ssl_cert => $ssl_cert,
  ssl_key  => $ssl_key
}
