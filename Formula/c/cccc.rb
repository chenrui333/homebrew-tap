class Cccc < Formula
  include Language::Python::Virtualenv

  desc "Local-first multi-agent collaboration kernel"
  homepage "https://chesterra.github.io/cccc/"
  url "https://files.pythonhosted.org/packages/0f/13/efb91aa70efde2c4f818240dafab1d8946629c3756cfd1089b33227d9a07/cccc_pair-0.4.35.tar.gz"
  sha256 "b99bdbc929a5b36e934162eaccadb67147c0d03bff5b66139fa115238ace233a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ChesterRa/cccc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "0235e10d845337e21081ed592dd4a9d391ea61806ad90e5393b748bbe2e40e93"
    sha256 cellar: :any, arm64_sequoia: "5a70c93dc9c73abca7bf23c02134da9fcc149b4837826a961fabc373405b8273"
    sha256 cellar: :any, arm64_sonoma:  "940f29b569a5c4936ff553c2d685459d4f3a45aa30305a495cefa09d16b1d48e"
    sha256 cellar: :any, arm64_linux:   "6832891cc8bfa0490399328f45a5c95af26e79e9bc6fd1fa00d0081153a0af29"
    sha256 cellar: :any, x86_64_linux:  "c037aa6bf8212d8d79820640cde16896c0524c1a0a1a2f7d41f1c462c183a52e"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build # Flit 2 uses ast.Str, removed in Python 3.14.
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  # httptools and propcache require exactly setuptools 82.0.1; Socksio needs a separate Flit 2 role.
  pypi_packages extra_packages:   %w[
                  calver cython expandvars flit-core==3.12.0 hatch-fancy-pypi-readme hatch-vcs hatchling packaging
                  pathspec
                  pdm-backend pkgconfig pluggy poetry-core pytoml setuptools==82.0.1 setuptools-scm tomlkit
                  trove-classifiers vcs-versioning wheel
                ],
                exclude_packages: %w[certifi cffi dingtalk-stream pydantic pydantic-core]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  # The original application requires cryptography<47; retain that API with upstream security fixes.
  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/47/93/ac8f3d5ff04d54bc814e961a43ae5b0b146154c89c61b47bb07557679b18/cryptography-46.0.7.tar.gz"
    sha256 "e4cfd68c5f3e0bfdad0d38e023239b96a2fe84146481852dffbcca442c245aa5"
  end

  # GHSA-m2h6-j472-rp4c: distinguish permitted and excluded wildcard DNS constraints.
  resource "cryptography-dns-constraints-patch" do
    url "https://github.com/pyca/cryptography/commit/4d035a4225965edeffd312079a510ef25fcfdcb2.patch?full_index=1"
    sha256 "58d8503bbf750c0d268c8c6ad15baddf1070892c8e2562ec3e852b5415da6cdf"
    livecheck { skip "Pinned security backport" }
  end

  # GHSA-jwv3-5hgf-82ww: bound duplicate-issuer signature validation.
  resource "cryptography-signature-budget-patch" do
    url "https://github.com/pyca/cryptography/commit/4a12cf49675a184e47f912b00b04f3a629283582.patch?full_index=1"
    sha256 "bb3274928011aaf7eaf27544fd9a6ffbf740ad39073ef92046122fafb195c3de"
    livecheck { skip "Pinned security backport" }
  end

  # Accepted test-only prerequisites preserve the complete upstream security regression changes.
  resource "cryptography-test-doubles-patch" do
    url "https://github.com/pyca/cryptography/commit/595008670c6f8b01b5a1f017d66fadc3885efeb7.patch?full_index=1"
    sha256 "f6ff62ac4e2ecf34fafdd83a56d7a38e41b4da5fa12c15177c383d2e16c6bc61"
    livecheck { skip "Pinned test prerequisite" }
  end

  resource "cryptography-test-marks-patch" do
    url "https://github.com/pyca/cryptography/commit/cf3fa7d89a3fbb047205a8385c411bd65c0cb3cd.patch?full_index=1"
    sha256 "094b4e6d3b783f914ad8c703a541042290c5681af90bf841062854812096c2e2"
    livecheck { skip "Pinned test prerequisite" }
  end

  # GHSA-g6cj-pr64-35w5: hide RSA encrypted-key decryption failures.
  resource "cryptography-pkcs7-patch" do
    url "https://github.com/pyca/cryptography/commit/53fccd93413a8d7f07d6d8999681f27b75cffa3f.patch?full_index=1"
    sha256 "c8c7c5f46ad6da3702cd6014ef80ed1f2da171735ef0b2eb0c527527daad66b4"
    livecheck { skip "Pinned security backport" }
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "dingtalk-stream" do
    # PyPI publishes only a wheel; the matching tag contains identical Python sources.
    url "https://github.com/open-dingtalk/dingtalk-stream-sdk-python/archive/refs/tags/v0.24.3.tar.gz"
    sha256 "f46bcfe2cc654159927b16ec6569459bddd8f49b1e1b701248b325a51a604a70"
  end

  resource "expandvars" do
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8a/02/91e3416a8fdd715abb903a952a6bec7cdd8d14eed55d415fc8595524c319/fastapi-0.141.1.tar.gz"
    sha256 "e8822fc40db1e1858054d7a949a888695bc9bdce70139178e33bd2871a453ca1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/6d/30/03b03951873a1a0ffc7e8ca0e10c15597b59e8d0e39260704cd2ea087bc4/filelock-3.32.4.tar.gz"
    sha256 "2bde2e4cf732e0153406d8a7bc80620ecf5e621fe0d25e41143c4e3b4733ff30"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "homebrew-flit-core-socksio" do
    define_singleton_method(:name) { "flit-core" }

    url "https://files.pythonhosted.org/packages/bb/92/e51c58d463ebbabb7b226662655cef6d17d3b4b83f570b08f6be0fe2b1b8/flit_core-2.3.0.tar.gz"
    sha256 "a50bcd8bf5785e3a7d95434244f30ba693e794c5204ac1ee908fc07c4acdbf80"
    livecheck { skip "Socksio's declared legacy build backend" }
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hatch-fancy-pypi-readme" do
    url "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz"
    sha256 "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/43/e5/d471fcb0e14523fe1c3f4ba58ca52480e7bd70ad7109a3846bc75892f7fb/httptools-0.8.0.tar.gz"
    sha256 "6b2a32f18d97e16e90827d7a819ffa8dbd8cc245fc4e1fa9d1095b54ef4bd999"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "lark-oapi" do
    url "https://files.pythonhosted.org/packages/8f/5f/a0cc291039501fae117602074006508c17d6c9c83f1daa61b8d029004662/lark_oapi-1.7.3.tar.gz"
    sha256 "e532e57fa295a1cc10e3432191f80638a082a190dc678cb2eddb6de301ff3573"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/f1/b2/73898a92113f532fe9cecaae97f070a12ec4c786d66af377a6f81d38e208/pdm_backend-2.4.9.tar.gz"
    sha256 "c41a852ccbf4b567b033db9b2ae78660d7a4ea49307719959ab88a01f0aabb2e"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/52/fd/0adde075cd3bfecd557bc7d757e00e231d34d8a6edb4c8d1642759254c21/pkgconfig-1.6.0.tar.gz"
    sha256 "4a5a6631ce937fafac457104a40d558785a658bbdca5c49b6295bc3fd651907f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz"
    sha256 "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"

    # Preserve the build bounds with the accepted manifest-exclusion security fix.
    patch do
      url "https://github.com/pypa/setuptools/commit/dd9f436a36486b4cb8a4c70a2321548b0be09b8f.patch?full_index=1"
      sha256 "0bda8d9d5766efa18bfcf1016a5dd0c57750792522b614ca9638d950fcded55d"
      type :backport
      resolves "GHSA-h35f-9h28-mq5c"
    end
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/3c/87/1ff7adcf6e03021ae58ce401565be3c9b8c739a44d14a8253d38b3754117/setuptools_scm-10.2.3.tar.gz"
    sha256 "f179ed3e2a63cf5823e5ee9aa9ca08386219400443a0553224d72dde3f206b44"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/c2/e3/7ca82ee24c82d344584abd5b8637b3bd056f2900226e8d82fc22f1184b92/trove_classifiers-2026.6.1.19.tar.gz"
    sha256 "c5132b4b61a829d11cfbd2d72e97f20a45ed6edb95e45c5efdeb5e00836b2745"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/f2/0f/3f86e61397dd33bf2ccf28188c40db6a740658aeebbbf6e7dbc101a1f487/uvicorn-0.52.4.tar.gz"
    sha256 "73acfee47a0b133c5de13d219492d62d8a31e935f4fe6e41a232451a15379f86"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/2c/41/aa4bf9664e4cda14c3b39865b12251e8e7d239f4cd0e3cc1b6c2ccde25c1/websocket_client-1.9.0.tar.gz"
    sha256 "9e813624b6eb619999a97dc7958469217c3176312b3a16a4bd1bc7e08a46ec98"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wechatbot-sdk" do
    url "https://files.pythonhosted.org/packages/b6/75/d8f1e16df0d9de9035a63441c6e673574b97e5ae2a2329b0b818f6069911/wechatbot_sdk-0.3.0.tar.gz"
    sha256 "65ecec0ef835391e8f7ce0035a2fc924ebf645e0d82ec9bdfd7f19bd27cccf98"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/31/33/ebe9e3d1f86c7a0b51094c0a146392045ca1631d2664889539dec8088a33/yarl-1.24.5.tar.gz"
    sha256 "e81b83143bee16329c23db3c1b2d82b29892fcbcb849186d2f6e98a5abe9a57f"
  end

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_bin("rust")
    %w[cryptography watchfiles].each do |name|
      resource(name).stage { system "cargo", "fetch", "--locked" }
    end
  end

  def patch_cryptography
    %w[
      cryptography-dns-constraints-patch cryptography-signature-budget-patch
      cryptography-test-doubles-patch cryptography-test-marks-patch cryptography-pkcs7-patch
    ].each do |name|
      # Keep all SDK production and regression-test hunks, excluding only release docs and CI wrappers.
      system "git", "apply", "--include=src/**", "--include=tests/**", resource(name).cached_download
    end
  end

  def install
    build_resources = %w[
      setuptools flit-core packaging wheel cython poetry-core tomlkit pathspec calver trove-classifiers
      vcs-versioning setuptools-scm pluggy hatchling hatch-vcs expandvars hatch-fancy-pypi-readme
      pdm-backend pkgconfig
    ]

    ENV.prepend_path "PATH", formula_opt_bin("rust")
    ENV.append_path "PYTHONPATH", formula_opt_prefix("maturin")/Language::Python.site_packages("python3.14")
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["NO_CYTHON_COMPILE"] = "true"
    ENV["PYYAML_FORCE_LIBYAML"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    build_python = formula_opt_bin("python@3.14")/"python3.14"
    venv = virtualenv_create(libexec, build_python, system_site_packages: false)
    ENV.prepend_path "PATH", libexec/"bin"
    build_resources.each { |name| venv.pip_install resource(name), build_isolation: false }

    resource("cryptography").stage do
      patch_cryptography
      venv.pip_install Pathname.pwd, build_isolation: false
    end

    # Build Socksio's unchanged pure wheel with its declared Flit 2 backend on supported Python.
    wheel_dir = buildpath/"socksio-wheels"
    wheel_dir.mkpath
    with_env(PYTHONPATH: nil) do
      legacy_python = formula_opt_bin("python@3.13")/"python3.13"
      legacy_venv = virtualenv_create(buildpath/"socksio-build", legacy_python, system_site_packages: false)
      %w[setuptools pytoml homebrew-flit-core-socksio].each do |name|
        legacy_venv.pip_install resource(name), build_isolation: false
      end
      resource("socksio").stage do
        system legacy_python, "-m", "pip", "--python=#{legacy_venv.root}/bin/python", "wheel",
               "--no-index", "--no-cache-dir", "--no-deps", "--no-build-isolation",
               "--wheel-dir=#{wheel_dir}", "."
      end
    end
    venv.pip_install wheel_dir.glob("*.whl"), build_isolation: false

    venv.pip_install resources.reject { |r|
      build_resources.include?(r.name) ||
        %w[cryptography pytoml socksio].include?(r.name) || r.name.end_with?("-patch")
    }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cccc version")
    assert_path_exists bin/"ccccd"
    ENV["PYDANTIC_DISABLE_PLUGINS"] = "__all__"

    (testpath/"consumer.py").write <<~PYTHON
      import datetime
      from importlib.metadata import version
      from pathlib import Path

      import yaml
      from pydantic import ValidationError
      from cccc.contracts.v1.ipc import DaemonRequest
      from cccc.implementation import load_selected_implementation, save_selected_implementation
      from cryptography import x509
      from cryptography.hazmat.primitives import hashes, serialization
      from cryptography.hazmat.primitives.asymmetric import padding, rsa
      from cryptography.hazmat.primitives.serialization import pkcs7
      from cryptography.x509.oid import NameOID

      request = DaemonRequest.model_validate({"op": "schema-only", "args": {"input": 7}})
      assert request.args["input"] == 7
      for payload, expected in [
          ({"op": 17}, "string_type"),
          ({"op": "schema-only", "unexpected": True}, "extra_forbidden"),
      ]:
          try:
              DaemonRequest.model_validate(payload)
          except ValidationError as error:
              assert error.errors()[0]["type"] == expected
          else:
              raise AssertionError("Invalid request schema accepted")

      state = Path("owned-state")
      save_selected_implementation("rust", home=state)
      assert load_selected_implementation(home=state) == "rust"
      save_selected_implementation("python", home=state)
      assert load_selected_implementation(home=state) == "python"
      assert yaml.load(yaml.dump({"route": "offline"}, Dumper=yaml.CSafeDumper),
                       Loader=yaml.CSafeLoader) == {"route": "offline"}

      assert version("cryptography") == "46.0.7"
      key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
      name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "Homebrew fixture")])
      now = datetime.datetime(2026, 1, 1, tzinfo=datetime.timezone.utc)
      cert = (x509.CertificateBuilder().subject_name(name).issuer_name(name)
              .public_key(key.public_key()).serial_number(1)
              .not_valid_before(now).not_valid_after(now + datetime.timedelta(days=1))
              .sign(key, hashes.SHA256()))
      message = b"owned native crypto fixture"
      envelope = (pkcs7.PKCS7EnvelopeBuilder().set_data(message).add_recipient(cert)
                  .encrypt(serialization.Encoding.DER, []))
      assert pkcs7.pkcs7_decrypt_der(envelope, cert, key, []) == message

      # A valid RSA-wrapped key with the wrong length must not disclose an AES key-size error.
      key_bytes = key.key_size // 8
      marker = b"\\x04\\x82" + key_bytes.to_bytes(2, "big")
      assert envelope.count(marker) == 1
      offset = envelope.index(marker) + len(marker)
      wrong_key = key.public_key().encrypt(b"A" * 15, padding.PKCS1v15())
      tampered = envelope[:offset] + wrong_key + envelope[offset + key_bytes:]
      try:
          pkcs7.pkcs7_decrypt_der(tampered, cert, key, [])
      except ValueError as error:
          assert str(error) == "Invalid padding bytes."
    PYTHON
    system libexec/"bin/python", "-I", testpath/"consumer.py"
    system formula_opt_bin("python@3.14")/"python3.14", "-m", "pip",
           "--python=#{libexec}/bin/python", "check"
  end
end
