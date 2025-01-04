# Changelog

## [0.2.0](https://github.com/ublue-os/forge/compare/v0.1.0...v0.2.0) (2024-05-27)


### Features

* **ansible:** add additional tags to container image ([6297b8f](https://github.com/ublue-os/forge/commit/6297b8f951eaa597d2499116a1f4ab0c0ff0fa8c))
* **ansible:** add example configurations to the setup ([#45](https://github.com/ublue-os/forge/issues/45)) ([e0df500](https://github.com/ublue-os/forge/commit/e0df50076e6067ad65588a7bfe77818470b495c6))
* **ansible:** add possibility to add build-args to podman build job ([#51](https://github.com/ublue-os/forge/issues/51)) ([cec7512](https://github.com/ublue-os/forge/commit/cec7512c570dd100d87b079c350440207abafde9))
* **nicegui:** easy navigation to home ([327c010](https://github.com/ublue-os/forge/commit/327c010ddddc62dfb7873adfe0b36d14ed567e2e))
* **nicegui:** make image table sortable ([af3bdc3](https://github.com/ublue-os/forge/commit/af3bdc37fb4d8b65043981257e942dfd8ba6651d))


### Bug Fixes

* **ansible:** use registry url for container image name ([d1a0f7f](https://github.com/ublue-os/forge/commit/d1a0f7fff2be3854a9b6765dea77eedb529f42a3))
* **nicegui:** empty image table should use same column names as when images are available ([ae10ebc](https://github.com/ublue-os/forge/commit/ae10ebc4acdf8e9bfab792cb2dbcaa22257c00d1))
* **registry:** disable performance constraints ([#52](https://github.com/ublue-os/forge/issues/52)) ([b213c82](https://github.com/ublue-os/forge/commit/b213c826cf224b5a21d45dcf3c0b5ef526f22ecd))

## 0.1.0 (2024-05-24)


### Features

* add caddy as reverse proxy ([#8](https://github.com/ublue-os/forge/issues/8)) ([aab9df8](https://github.com/ublue-os/forge/commit/aab9df8e0417f7b76435dba63398f095f2c08545))
* add container registry and mini ca ([#3](https://github.com/ublue-os/forge/issues/3),[#4](https://github.com/ublue-os/forge/issues/4)) ([0714214](https://github.com/ublue-os/forge/commit/07142142477372db49d1e30bc2e808a8a22c3af1))
* add graphical user interface ([#34](https://github.com/ublue-os/forge/issues/34)) ([4f2130b](https://github.com/ublue-os/forge/commit/4f2130bcce9eea6e9ce12ac16f34eed376f7f471))
* add semaphore to the stack ([#10](https://github.com/ublue-os/forge/issues/10)) ([5b5fbd6](https://github.com/ublue-os/forge/commit/5b5fbd6a5644198b7ab553a10d144b3f4c9197db))
* **ansible:** add role for variable debugging ([a2a37bd](https://github.com/ublue-os/forge/commit/a2a37bd54c059a2cfd88b068e5c68f3989027289))
* **ansible:** allow for input variable files to configure forge behavior ([#13](https://github.com/ublue-os/forge/issues/13)) ([cb4d82c](https://github.com/ublue-os/forge/commit/cb4d82c7cf9b9ad2c9887ea0b4ca4adf62bb4c95))
* **ansible:** give feedback on elapsed time per task and make output human readable ([f7572aa](https://github.com/ublue-os/forge/commit/f7572aa4b788e133677b244d0becee7deb868cb3))
* **ansible:** playbooks to build and clone projects ([#13](https://github.com/ublue-os/forge/issues/13)) ([2874825](https://github.com/ublue-os/forge/commit/2874825341910e3dcae4c7e6f50e56a9ed1acda4))
* automatically setup forge ([#10](https://github.com/ublue-os/forge/issues/10)) ([bbe78ee](https://github.com/ublue-os/forge/commit/bbe78ee922e7e71afc04831cb94c8daffea4fc36))
* check if user use unprivileged port 80 ([c691eba](https://github.com/ublue-os/forge/commit/c691ebaeac8fb549801e108679ea3dfc8718443f))
* check installation pre-requisites ([#14](https://github.com/ublue-os/forge/issues/14)) ([402fefe](https://github.com/ublue-os/forge/commit/402fefe0e42b2a6c189017a3bf27ba94529c9873))
* configure host system ([#12](https://github.com/ublue-os/forge/issues/12)) ([abffb75](https://github.com/ublue-os/forge/commit/abffb756d6423ee2fce0015abd825d116360f882))
* create ssh key for automation tasks ([717998b](https://github.com/ublue-os/forge/commit/717998b801729ee6170c92514b5052ca6fcf1c2b))
* **devcontainer:** add just command syntax highlighting ([7ae5826](https://github.com/ublue-os/forge/commit/7ae5826f4a2b38826c0634679391d224a1d167f8))
* enhance setup and management ([#14](https://github.com/ublue-os/forge/issues/14)) ([ec03273](https://github.com/ublue-os/forge/commit/ec03273f8f8422e867d35b8221da30881c1108d3))
* host configuration ([12176c5](https://github.com/ublue-os/forge/commit/12176c5718199d2e7ff77ab6e5194e712aa1214e))
* **just:** update recipes names and allow for input variable files ([#13](https://github.com/ublue-os/forge/issues/13)) ([b9b5c7f](https://github.com/ublue-os/forge/commit/b9b5c7f1171164f0a1967177f16d686a074aaed0))
* **main:** add just configuration file ([c007e2b](https://github.com/ublue-os/forge/commit/c007e2b5051b971c884629c93d64eec8d336ced9))
* **main:** check if podman is installed ([d855d03](https://github.com/ublue-os/forge/commit/d855d03eb9712f98112fa8c22b55cb4688aaa948))
* **main:** ditch ansible-semaphore and use ansible directly ([2e8cc2f](https://github.com/ublue-os/forge/commit/2e8cc2f51af163f815aa1eae5fbc83741f6216e9))
* **main:** install ansible collections ([8d0fe54](https://github.com/ublue-os/forge/commit/8d0fe541b02ca5b1711b8921258a735f766bd2c5))
* **main:** keep ansible running ([101652e](https://github.com/ublue-os/forge/commit/101652eb312a9d512e27e33c002f3afcabb7890d))
* **main:** remove ansible semaphore ([f1d1db3](https://github.com/ublue-os/forge/commit/f1d1db3c57632a9a38a5a29efb40bad5e3fb9bc8))
* **main:** replace caddy with traefik as reverse proxy ([5d7c375](https://github.com/ublue-os/forge/commit/5d7c37544ce0f57dafdc6391b33f4967dad513e9))
* **main:** rewrite and update pod setup ([742f74e](https://github.com/ublue-os/forge/commit/742f74eec2e22640c898c9b642321e7a4a72febe))
* **main:** show container info in setup ([e2e3823](https://github.com/ublue-os/forge/commit/e2e382324b6971f6e08c23c63a4611bc8587fe0a))
* manage forge with one command ([#14](https://github.com/ublue-os/forge/issues/14)) ([83379a0](https://github.com/ublue-os/forge/commit/83379a0d7272341523ca50b5b006637bb33a8d1b))
* **nicegui:** add about section ([f677744](https://github.com/ublue-os/forge/commit/f67774443f27670197e3a9fc439e68624c9aaed8))
* **nicegui:** add favicon ([5b81eb5](https://github.com/ublue-os/forge/commit/5b81eb55667cfe1ffcbcedf001890159e83e597e))
* **nicegui:** add first content to 'home' ([ed3f58e](https://github.com/ublue-os/forge/commit/ed3f58ed93e4cca93dfb487baf814aaf110fe99b))
* **nicegui:** drop down menu for navigation ([3ee6a06](https://github.com/ublue-os/forge/commit/3ee6a060e12d716760d5b4d9402f76452babffbe))
* **nicegui:** show list of all images stored in container registry ([#43](https://github.com/ublue-os/forge/issues/43)) ([83f047f](https://github.com/ublue-os/forge/commit/83f047f2d64486b1207b974370bbac66e67b912d))
* simple setup script ([ff7a673](https://github.com/ublue-os/forge/commit/ff7a673500283abe14e1a01f07918e5b85887dcf))


### Bug Fixes

* add hint for missing jq installation ([4698b47](https://github.com/ublue-os/forge/commit/4698b47ed39250dd1dd9bedda04d56836f178573))
* **ansible:** make long running tasks asynchronous ([#42](https://github.com/ublue-os/forge/issues/42)) ([ba1eb2b](https://github.com/ublue-os/forge/commit/ba1eb2bc79bfe94f945bdf22ec695c9131bcca0e))
* ConfigMap is obsolete ([7501e1d](https://github.com/ublue-os/forge/commit/7501e1d7aa2bae3c80b47c5ecf93dc147bc4db0f))
* **devcontainer:** missing ansible extension configuration ([a885686](https://github.com/ublue-os/forge/commit/a88568658c73fbbabfa92a3370ee2df710ee60e9))
* **devcontainer:** missing line comment symbol ([f077f79](https://github.com/ublue-os/forge/commit/f077f79a0a67b12a29ebd82dcd687cad31f2a0b5))
* ini container fails on normal startup ([258a1ce](https://github.com/ublue-os/forge/commit/258a1ce7f729744fbb2bcff42787e784d2627a68))
* **just:** adapt to decisions made during gui implementation ([79ede2d](https://github.com/ublue-os/forge/commit/79ede2d43122307991926099aa0e5bcfb2fabe2a))
* **main:** use full podman.sock path not only user id ([d93122b](https://github.com/ublue-os/forge/commit/d93122baf13c0f4ea865ec00b27f641d88ccd456))
* make sure container get's stopped once job is done ([882340f](https://github.com/ublue-os/forge/commit/882340fa5c5d4c7b6623e10b963ce2476ae28679))
* **nicegui:** better error handling ([f5c95c8](https://github.com/ublue-os/forge/commit/f5c95c8d1eb180579ed57beda1e116ac91e125a3))


### Miscellaneous Chores

* prepare release 0.1.0 ([a7576d9](https://github.com/ublue-os/forge/commit/a7576d9a74542d44054f91a9df5cbc51a336b9f4))
