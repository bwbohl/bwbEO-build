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

## init.sh

Collects data concerning your application, e.g. application name or copyright statement, foldername. Writes files to `./build/$foldername/`:

* application.ini
* brand.dtd
* brand.properties
* prefs.js
* edirom-online (mac executable)
* PkgInfo
* config.sh
* build.sh

Then copies all written files to  `./submodules/webapp-xul-wrapper` overwriting existing ones.

## prepare-webapp-xul-wrapper.sh

1. Runs `fetch_xulrunner.sh`from `./submodules/webapp-xul-wrapper/`,
2. initializes and updates git submodules in `./submodules/webapp-xul-wrapper/`,
3. copies edirom-online module for webapp-xul-wrapper from `./submodules/webapp-xul-wrapper-edirom-online-module/``

## build-exist.sh

Retrieves or builds WAR of a specified version of eXist-db. If you want to use your prebuild version do not execute `build-exist.sh` and extract your WAR file to `./staging/exist/`.

## build-digilib.sh

Retrieves or builds WAR of a specified version of digilib. If you want to use your prebuild version do not execute `build-digilib.sh` and extract your WAR file to `./staging/digilib/`.

## build-jetty-module.sh

Retrieves or builds a specified version of jetty. If you want to use your prebuild version do not execute `build-jetty-module.sh` and copy your build to `./staging/jetty/`.

## build.sh

1. checks for build requirements and gives feedback
2. builds Edirom-Online XAR package
3. builds EditionExample XAR package
4. builds sourceManager XAR package
5. builds sourceImageCartographer XAR package with (-Ddigilib.server=http://nashira.upb.de:7000/Scaler/)
6. copies `./staging/jetty/` to `./submodules/webapp-xul-wrapper/modules/jetty/`
7. copies `./staging/exist/`to jetty/webapps
8. copies `./staging/digilib/`to jetty/webapps

## build-webapp-xul-wrapper.sh

# Output

Your built application can be found in `submodules/webapp-xul-wrapper/staging` resp. `submodules/webapp-xul-wrapper/build`.
