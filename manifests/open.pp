class nbcrtrain::open
{
  #epel repo
  exec { 'install_epel':
    command => '/bin/yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
    creates => '/etc/yum.repos.d/epel.repo'
  }

  Package { ensure => 'installed' }
  $python_deps    = [ 'python2-pip', 'python-psutil']
  $other_packages = [ 'libXft', 'xorg-x11-xauth', 'screen', 'bzip2', 'which', 'rsync', 'gcc', 'gcc-c++', 'python-devel', 'cmake', 'git', 'unzip', 'tree', 'wget','tcsh','xauth','xclock', 'qt' ,'qt-devel', 'opencv', 'opencv-python','numpy','numpy-f2py','scipy' ]
  $mesa_packages  = [ 'mesa-libGL-devel','mesa-libEGL-devel','mesa-libGLES-devel' ]
  $fonts_packages = [ 'xorg-x11-fonts-100dpi','xorg-x11-fonts-75dpi','xorg-x11-fonts-ISO8859-1-100dpi','xorg-x11-fonts-ISO8859-1-75dpi','xorg-x11-fonts-ISO8859-14-100dpi','xorg-x11-fonts-ISO8859-14-75dpi','xorg-x11-fonts-ISO8859-15-100dpi','xorg-x11-fonts-ISO8859-15-75dpi','xorg-x11-fonts-ISO8859-2-100dpi','xorg-x11-fonts-ISO8859-2-75dpi','xorg-x11-fonts-ISO8859-9-100dpi','xorg-x11-fonts-ISO8859-9-75dpi','xorg-x11-fonts-Type1','xorg-x11-fonts-cyrillic','xorg-x11-fonts-ethiopic','xorg-x11-fonts-misc']
  $pip_packages   = [ 'argparse','psutil','lockfile','chmutil', 'scikit-learn' ]
  package { $python_deps: }
  package { $other_packages: }
  package { $fonts_packages: }
  package { $mesa_packages: }
  
  package { $pip_packages:
    ensure   => 'installed',
    provider => 'pip',
    require  => Package['python2-pip'],
  }

  # Install IMOD 4.9.4
  exec { 'install_imod': 
    command => '/bin/cd ~; /bin/wget http://bio3d.colorado.edu/imod/AMD64-RHEL5/imod_4.9.4_RHEL7-64_CUDA6.5.sh;
                /bin/chmod a+x imod_4.9.4_RHEL7-64_CUDA6.5.sh;
                /bin/sh imod_4.9.4_RHEL7-64_CUDA6.5.sh -yes;
                /bin/rm imod_4.9.4_RHEL7-64_CUDA6.5.sh',
    creates =>  '/usr/local/IMOD/bin/imod'
  }
 
  # Install Singularity
  exec { 'install_singularity':
    command => '/bin/cd ~;export VERSION=2.3.1;
                /bin/wget https://github.com/singularityware/singularity/releases/download/$VERSION/singularity-$VERSION.tar.gz;
                /bin/tar xvf singularity-$VERSION.tar.gz;
                /bin/cd singularity-$VERSION;
                /bin/sh configure --prefix=/usr/local;
                /bin/make;
                /bin/make install;
                /bin/cd ..;/bin/rm -f singularity-$VERSION.tar.gz;
                /bin/rm -rf singularity-$VERSION',
    creates => '/usr/bin/singularity'
  }
}
