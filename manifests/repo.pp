# = Definition: git::repo
#
# == Parameters:
#
# $target::   Target folder. Required.
#
# $bare::     Create a bare repository. Defaults to false.
#
# $source::   Source to clone from. If not specified, no remote will be used.
#
# $user::     Owner of the repository. Defaults to root.
#
# == Usage:
#
#   git::repo {'mygit':
#     target => '/home/user/puppet-git',
#     source => 'git://github.com/theforeman/puppet-git.git',
#     user   => 'user',
#   }
#
define git::repo (
  $target,
  $bare    = false,
  $source  = false,
  $user    = 'root'
) {
  require git::params

  $bare_flag = $bare ? {
    true => '--bare',
    default => '',
  }

  $creates = $bare_flag ? {
    true  => "${target}/objects",
    false => "${target}/.git",
  }

  if $source {
    $cmd = "${git::params::bin} clone --recursive ${bare_flag} ${source} ${target}"
  } else {
    $cmd = "${git::params::bin} ${bare_flag} init ${target}"
  }

  exec { "git_repo_for_${name}":
    command => $cmd,
    creates => $creates,
    require => Class['git::install'],
    user    => $user,
    logoutput => 'on_failure',
    cwd => '/tmp',
  }
}
