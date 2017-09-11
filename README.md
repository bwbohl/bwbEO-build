# bwbEO-build

Theses scripts are intended to configure webapp-xul-wrapper for building a webapp wrapper including eXist-db and digilib served by jetty.

After checking out your working copy please execute the following commands in order to complete the setup:

```shell
git submodule init
git submodule update
```

Now you can start your individualised build process by executing the script in the following order:

```shell
init.sh
prepare-webapp-xul-wrapper.sh
build-exist.sh
build-digilib.sh
build-jetty-module.sh
build.sh
build-webapp-xul-wrapper.sh
```

Your built application can be found in `submodules/webapp-xul-wrapper/staging` resp. `submodules/webapp-xul-wrapper/build`.
