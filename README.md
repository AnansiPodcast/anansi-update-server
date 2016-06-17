# Electron Update Server

A simple update server for OSX electron apps writen in ruby.

## Getting started

This simple app won't host your app releases, for this purpose you'll need to setup an Amazon S3 Bucket or an FTP server.

### Configuring this app

Create your configuration file by running:

    cp config.sample.yml config.yml

`base_path` is the server address that should contain update channel directories and update files.

### Setup the server

This app will let you set how many update channel you need (like stable and beta), you just need to create a folder for each update channel, something like:

      /stable
      /beta

### Deploying updates

To deploy updates you'll need to put `.zip` files with the version name in the update channel directories, like:

    http://my_update_server.com/stable/1.0.0.zip

## Installing dependencies

Just run:

    bundle install

## Running the app

    ruby app.rb
