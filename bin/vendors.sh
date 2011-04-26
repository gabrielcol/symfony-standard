#!/bin/sh

DIR=`php -r "echo dirname(dirname(realpath('$0')));"`
VENDOR="$DIR/vendor"
VERSION=`cat "$DIR/VERSION"`
BUNDLES=$VENDOR/bundles

# initialization
if [ "$1" = "--reinstall" -o "$2" = "--reinstall" ]; then
    rm -rf $VENDOR
fi

# just the latest revision
CLONE_OPTIONS=''
if [ "$1" = "--min" -o "$2" = "--min" ]; then
    CLONE_OPTIONS='--depth 1'
fi

mkdir -p "$VENDOR" && cd "$VENDOR"

##
# @param destination directory (e.g. "doctrine")
# @param URL of the git remote (e.g. http://github.com/doctrine/doctrine2.git)
# @param revision to point the head (e.g. origin/HEAD)
#
install_git()
{
    INSTALL_DIR=$1
    SOURCE_URL=$2
    REV=$3

    echo "> Installing/Updating " $INSTALL_DIR

    if [ -z $REV ]; then
        REV=origin/HEAD
    fi

    if [ ! -d $INSTALL_DIR ]; then
        git clone $CLONE_OPTIONS $SOURCE_URL $INSTALL_DIR
    fi

    cd $INSTALL_DIR
    git fetch origin
    git reset --hard $REV
    cd ..
}

# Assetic
install_git assetic http://github.com/kriswallsmith/assetic.git #v1.0.0alpha2

# Symfony
install_git symfony http://github.com/symfony/symfony.git #v$VERSION

# Doctrine ORM
install_git doctrine http://github.com/doctrine/doctrine2.git 2.0.4

# Doctrine DBAL
install_git doctrine-dbal http://github.com/doctrine/dbal.git 2.0.4

# Doctrine Common

install_git doctrine-common http://github.com/doctrine/common.git

# Doctrine MongoDB
install_git doctrine-mongodb http://github.com/doctrine/mongodb.git

# Doctrine MongoDB
install_git doctrine-mongodb-odm http://github.com/doctrine/mongodb-odm.git

# Doctrine CouchDB
install_git doctrine-couchdb-odm http://github.com/doctrine/couchdb-odm.git

# Doctrine PHPCR
install_git doctrine-phpcr-odm http://github.com/doctrine/phpcr-odm.git
cd doctrine-phpcr-odm
git submodule init
git submodule update --recursive
cd $VENDOR

# Swiftmailer
install_git swiftmailer http://github.com/swiftmailer/swiftmailer.git origin/4.1

# Twig
install_git twig http://github.com/fabpot/Twig.git

# Twig Extensions
install_git twig-extensions http://github.com/fabpot/Twig-extensions.git

# Monolog
install_git monolog http://github.com/Seldaek/monolog.git

# SensioFrameworkExtraBundle
mkdir -p $BUNDLES/Sensio/Bundle
cd $BUNDLES/Sensio/Bundle

install_git FrameworkExtraBundle http://github.com/sensio/SensioFrameworkExtraBundle.git

# Johannes Bundles
mkdir -p $BUNDLES/JMS
cd $BUNDLES/JMS

    # SecurityExtraBundle
    install_git SecurityExtraBundle http://github.com/schmittjoh/SecurityExtraBundle.git

    # DebuggingBundle
    install_git DebuggingBundle http://github.com/schmittjoh/DebuggingBundle.git

# Symfony bundles
mkdir -p $BUNDLES/Symfony/Bundle
cd $BUNDLES/Symfony/Bundle

    # WebConfiguratorBundle
    install_git WebConfiguratorBundle http://github.com/symfony/WebConfiguratorBundle.git

    # DoctrinePHPCRBundle
    install_git DoctrinePHPCRBundle http://github.com/symfony-cmf/DoctrinePHPCRBundle.git

# FOS bundles
mkdir -p $BUNDLES/FOS
cd $BUNDLES/FOS

    # FOSUserBundle
    install_git UserBundle git@github.com:FriendsOfSymfony/UserBundle.git

    # FOSRestBundle
    install_git RestBundle git@github.com:FriendsOfSymfony/RestBundle.git

    # FOSFacebookBundle
    install_git FacebookBundle git@github.com:FriendsOfSymfony/FacebookBundle.git

    # FOSTwitterBundle
    install_git TwitterBundle git@github.com:FriendsOfSymfony/TwitterBundle.git

# facebook php sdk
cd $VENDOR
install_git facebook http://github.com/facebook/php-sdk.git

# Liip bundles
mkdir -p $BUNDLES/Liip
cd $BUNDLES/Liip

    # LiipHelloBundle
    install_git HelloBundle git@github.com:liip/HelloBundle.git

    # LiipFunctionalTestBundle
    install_git FunctionalTestBundle git@github.com:liip/FunctionalTestBundle.git

    # LiipXsltBundle
    install_git XsltBundle git@github.com:liip/XsltBundle.git

    # LiipMultiplexBundle
    install_git MultiplexBundle git@github.com:liip/MultiplexBundle.git

    # LiipContainerWrapperBundle
    install_git ContainerWrapperBundle git@github.com:liip/ContainerWrapperBundle.git

    # LiipCacheControlBundle
    install_git CacheControlBundle git@github.com:liip/CacheControlBundle.git

# Update the bootstrap files
$DIR/bin/build_bootstrap.php

# Clear the cache
$DIR/app/console cache:clear

# Update assets
$DIR/app/console assets:install $DIR/web
