class Paperai < Formula
  include Language::Python::Virtualenv

  desc "AI for medical and scientific papers"
  homepage "https://github.com/neuml/paperai"
  url "https://files.pythonhosted.org/packages/78/e5/c4cfb4559d8ababb773d28ac9224de5fd455c8abbe913bf0d2cd0fb9ed2a/paperai-2.5.0.tar.gz"
  sha256 "e13e4d6d17bfb115daab1fc8f76e850afba35627c097c93ca8f5bb4ed354afbf"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "08126fe0bd5519c4a32cca7b5747bb27de216f7caae29d8702ac4dc1914ec7c0"
    sha256 arm64_sequoia: "a1f1e07099c104871dd30b66767cc097c344eb47cda547f98d25aeb214ebc529"
    sha256 arm64_linux:   "dc65d03192aafaee976483e7d9c976dc84c23d3b6df396add2b30b37ff289784"
    sha256 x86_64_linux:  "852c7422e0073e8b8a08a4dce889210b93db411aab0f62e44d4a29a6e549f62f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "m4" => :build
  depends_on "maturin" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "rust" => :build
  depends_on "xz" => :build
  depends_on "abseil"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libffi"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "onnx"
  depends_on "openblas"
  depends_on "openssl@4"
  depends_on "pillow" => :no_linkage
  depends_on "protobuf"
  depends_on "pydantic" => :no_linkage
  depends_on "python-packaging" => :no_linkage
  depends_on "python@3.14"
  depends_on "pytorch"
  depends_on "rpds-py" => :no_linkage
  depends_on "scipy" => :no_linkage
  depends_on "sleef"
  depends_on "sqlite"

  on_macos do
    depends_on "libomp"
  end

  pypi_packages exclude_packages: %w[
                  bitsandbytes
                  certifi
                  cryptography
                  faiss-cpu
                  litellm
                  numpy
                  packaging
                  pillow
                  pydantic
                  pydantic-core
                  rpds-py
                  scipy
                  sqlite-vec
                  torch
                ],
                extra_packages:   %w[
                  calver coherent-licensed cython==3.2.5 dunamai expandvars flit-core
                  hatch-fancy-pypi-readme hatch-vcs hatchling==1.33.0 jinja2 markupsafe meson meson-python
                  networkx pathspec pdm-backend pkgconfig pluggy poetry-core pyproject-metadata scikit-build-core
                  semantic-version setuptools setuptools-rust setuptools-scm swig==4.3.1.post0 tomlkit
                  trove-classifiers uv-build==0.11.33 uv-dynamic-versioning wheel
                ]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/6c/4c/bdccd81e9ee225b69c60e7766c9a5b05364f118f4d383713b89a682d772d/aiohttp-3.14.5.tar.gz"
    sha256 "5558a7f5a05af9ecf744af91e5baefc436f93c9333e656c27ec253f9a6bbe178"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "annoy" do
    url "https://files.pythonhosted.org/packages/07/38/e321b0e05d8cc068a594279fb7c097efb1df66231c295d482d7ad51b6473/annoy-1.17.3.tar.gz"
    sha256 "9cbfebefe0a5f843eba29c6be4c84d601f4f41ad4ded0486f1b88c3b07739c15"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "bitsandbytes" do
    url "https://github.com/bitsandbytes-foundation/bitsandbytes/archive/08a9956b939857ae2c4fbd56753960cc370fa7cf.tar.gz"
    version "0.50.2"
    sha256 "3afa2437b2fed38237895041082f31f825432837be147d8863d32da94f18ec28"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ca/6b/2bc953d6f0b87505636d0a7c16e46a47ab6c49df4a278ac9c0b1c1732e65/boto3-1.43.127.tar.gz"
    sha256 "b5417e81d439b35ccf3a1eb51fa06cf9c97167c9a6beaa1929175ee9840d505a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8f/45/b4e606b0f66c11c6bd44e91381aa562c6b4dacf478b97b461a429036a89a/botocore-1.43.127.tar.gz"
    sha256 "93bae360fb3a6f1b8e36593faa8bbbfa05b19866f7a37e9606a98f13394156f8"
  end

  resource "build-maturin-1.15.0" do
    self.name = "maturin"
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "build-setuptools-80.9.0" do
    self.name = "setuptools"
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "build-setuptools-scm-3.5.0" do
    self.name = "setuptools-scm"
    url "https://files.pythonhosted.org/packages/b2/f7/60a645aae001a2e06cf4b8db2fba9d9f36b8fd378f10647e3e218b61b74b/setuptools_scm-3.5.0.tar.gz"
    sha256 "5bdf21a05792903cafe7ae0c9501182ab52497614fa6b1750d9dbae7b60c1a87"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "coherent-licensed" do
    url "https://files.pythonhosted.org/packages/cd/e9/63d2dcccb5496cc99d96f29a8a5f3e2c6ed0bba7fedb840862f92816ee17/coherent_licensed-0.5.2.tar.gz"
    sha256 "d8071403ce742d3ac3592ddc4fb7057a46caffb415b928b4d52802e5f208416d"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/3f/3b/ebd94c8b85f8e41b5015a9ed94ee3df866024d480d05cd08b774684fb81d/cython-3.2.5.tar.gz"
    sha256 "3dd42e4cf36ad15f265bdfec2337cc00c688c8eb6d374ffd13bb19437c27bba1"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/12/18/020d3b27a10450ddb11429f637404e8ea67ecf4d9fd999d4f1d553f25506/dunamai-1.26.2.tar.gz"
    sha256 "84ea45eddf9bb4b40df7610b1b22a03137365e6257dbf9d7b72128fdccca564c"
  end

  resource "expandvars" do
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "faiss-cpu" do
    url "https://github.com/faiss-wheels/faiss-wheels.git",
        tag:      "v1.13.2",
        revision: "1fe76d377bfc90072024ca97c9ab00c7bf2e98b8"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/c9/53/f6fed628a0c3d6a284125a93f9145b02ecc2c394735a878b5ad9938c8e17/fastapi-0.162.2.tar.gz"
    sha256 "9ebd2a69b579141315b2447d8e3f518e6fd909abd6c01cac5cc6b06d5c8841f4"
  end

  resource "fastapi-mcp" do
    url "https://files.pythonhosted.org/packages/6d/1e/e3ba42f2e240dc67baabc431c68a82e380bcdae4e8b7d1310a756b2033fc/fastapi_mcp-0.4.0.tar.gz"
    sha256 "d4ca9410996f4c7b8ea0d7b20fdf79878dc359ebf89cbf3b222e0b675a55097d"
  end

  resource "fasttext-wheel" do
    url "https://files.pythonhosted.org/packages/c8/51/022e84b23ec435248a39f727dae94240321ebe2fdc104800de80410e1550/fasttext-wheel-0.9.2.tar.gz"
    sha256 "056e088318ef0e0cc690c4cb18637320eaa3cdb986b62d67bb50d6a7a82e4051"
  end

  resource "fastuuid" do
    url "https://files.pythonhosted.org/packages/c3/7d/d9daedf0f2ebcacd20d599928f8913e9d2aea1d56d2d355a93bfa2b611d7/fastuuid-0.14.0.tar.gz"
    sha256 "178947fc2f995b38497a74172adee64fdeb8b7ec18f2a5934d037641ba265d26"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/ec/ca/cf17b88a8df95691275a3d77dc0a5ad9907f328ae53acbe6795da1b2f5ed/fonttools-4.61.1.tar.gz"
    sha256 "6675329885c44657f826ef01d9e4fb33b9158e9d93c537d84ad8399539bc6f69"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "ggml-py" do
    url "https://files.pythonhosted.org/packages/8b/c5/8bc941b59a8afc3be7c39f0b929970e902af8ceb86d8f10b84f64c1cde3a/ggml_py-0.10.1.tar.gz"
    sha256 "77e840e8b87c319456331296333c641bc96232076dac00bb6b4563ab9422c71a"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
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
    url "https://files.pythonhosted.org/packages/7a/f1/e47b937226ae3b093bbd0132eb0b7ee5bfad12c2b5324afd10ae49946b05/hatchling-1.33.0.tar.gz"
    sha256 "4c422bd4d554fcff5de5b73e9596f85e41e9f97f7e553d8f7595ecb31a627bef"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/2f/18/d91c20f815df6cc496a5d0ad8db6d274dad5c0cfcd59babfa2440a9aba44/hf_xet-1.8.0.tar.gz"
    sha256 "10ed23b51dacf7917d64f335c25048deb470efa755e9989b218fc0531386138e"
  end

  resource "hnswlib" do
    url "https://files.pythonhosted.org/packages/cf/7a/1a9b1405f2eb59515f06c3074750b03e0e96edf7fee0f6dd6df81d9c21d7/hnswlib-0.8.0.tar.gz"
    sha256 "cb6d037eedebb34a7134e7dc78966441dfd04c9cf5ee93911be911ced951c44c"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/25/2a/484d112c0d8fc5f665d7b65137ac9cdb2953c982391598c3597968a12ee7/huggingface_hub-1.33.0.tar.gz"
    sha256 "367be21a201db9523eddf8aeac7048f2602c1b308691c97640d5e72ed188007e"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/67/de/8dfd06a2153d8ab6a83a8ca8f8ae3ff860ce2fe324ee6a5d05294b621c2a/jiter-0.19.0.tar.gz"
    sha256 "ba3064f8be276d7cfb83c2fb85c858be533da2c2f80f9b048c3781b45a57a195"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  # The sdist omits workspace crates required by its unchanged Cargo.lock.
  # Use the complete official release without changing dependency metadata or native features.
  resource "litellm" do
    url "https://github.com/BerriAI/litellm/archive/e6f080fb5633aa71ea81b652bd72069aff1f0228.tar.gz"
    version "1.108.4"
    sha256 "ec2a9eb323de79bf3afd4aa2e4ac2f583fb434cfbaed716c4436305cc6f7d3b8"
  end

  resource "llama-cpp-python" do
    url "https://files.pythonhosted.org/packages/ec/e9/e7de2b0463ea3ffbf0ede6cb21b58c1258a8f6521aae45ca773a59fe7cf3/llama_cpp_python-0.3.36.tar.gz"
    sha256 "832db0699007f1be95a7e41ef12e88926b02ba836461e36a36372db2760c1a2e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/ba/93/0142dc84a666daf8ad51a34268f34c12fd6fda4f3810c4be2504eecc8212/mcp-1.30.0.tar.gz"
    sha256 "445414625fce5c295faa505bb11bacece661ab6f4028d57c935db57820b7a3e4"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "meson" do
    url "https://files.pythonhosted.org/packages/f9/c9/8c9983f4f3d9c4e22fd76bcf8cd053e4472aefae45fd044669b6daa34b53/meson-1.12.1.tar.gz"
    sha256 "ab0a6ca09f8ef70c564c8241fb5a23957886a0b53fb58412b5e07eaf07dba743"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/26/bd/fdb26366443620f1a8a4d4ec7bfa37d1fbbe7bf737b257c205bbcf95ba95/meson_python-0.18.0.tar.gz"
    sha256 "c56a99ec9df669a40662fe46960321af6e4b14106c14db228709c1628e23848d"
  end

  resource "model2vec" do
    url "https://files.pythonhosted.org/packages/2a/73/03badf0a639cdad59db887928f17a187f4240f021f2d3656ef39795058b7/model2vec-0.7.0.tar.gz"
    sha256 "bf5d0420615e356dd8046794a057bb4f13c50253c44f0d0d1f4441bb489a6ed3"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cc/52/1ec7ead2c7528bf3d1db73e886fa4df10f9e6f0eb7854a448b7090cfcef7/msgpack-1.2.4.tar.gz"
    sha256 "475c44e12f2a5de766a8448783f149c9b33f3f49b88953c6cd739a77d93c732c"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/7b/6b/29ef8e752f5854dcc267ded0652c475bec99b86f255957a0d4fcad657b18/multidict-7.2.1.tar.gz"
    sha256 "e8af3e6f1bdbc31fd762b094133b478b89988eaebc63cbe82b1d9e3bbd15cede"
  end

  resource "nanopq" do
    url "https://files.pythonhosted.org/packages/ac/17/54352917ab78a1589162b112a1223c28eecf8b14efa957573b26d63af009/nanopq-0.2.2.tar.gz"
    sha256 "27564b13f06b8b42821730bf8fb981c85e9a10fa08cc3b919b7f84bbaf21771f"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/67/43/e11d75a7fb635c6f63dd6e176cb3e050ec2fee35f2f2267b332a6ad351ec/narwhals-2.28.0.tar.gz"
    sha256 "2d9860c80d6610820826e94c6e42ce4b1d92d89cdd479586e652a8d211dab345"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/d5/d4/03b70b8bb3784efab3b67e04622daf574711d20a0843bacfe78728966df8/openai-3.48.0.tar.gz"
    sha256 "8786c46c2496baef3ca840ff6abff59882a7735b08f610bfe96fcf407338527d"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pdf-annotate" do
    url "https://files.pythonhosted.org/packages/67/89/ae3a838ab916de7e4ec95cadd31349caeb102d01df004d7618710cded945/pdf-annotate-0.12.0.tar.gz"
    sha256 "a38b8f6aa61cf32460348f972857e46358e7b6d9858be1efbffa1035a885212b"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/34/a4/5cec1112009f0439a5ca6afa8ace321f0ab2f48da3255b7a1c8953014670/pdfminer_six-20260107.tar.gz"
    sha256 "96bfd431e3577a55a0efd25676968ca4ce8fd5b53f14565f85716ff363889602"
  end

  resource "pdfrw" do
    url "https://files.pythonhosted.org/packages/61/96/cbde98b96115d10694010e584d00d39f7b97905e1c8303e6ffbb84080e6a/pdfrw-0.4.tar.gz"
    sha256 "0dc0494a0e6561b268542b28ede2280387c2728114f117d3bb5d8e4787b93ef4"
  end

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
  end

  resource "pgvector" do
    url "https://files.pythonhosted.org/packages/25/6c/6d8b4b03b958c02fa8687ec6063c49d952a189f8c91ebbe51e877dfab8f7/pgvector-0.4.2.tar.gz"
    sha256 "322cac0c1dc5d41c9ecf782bd9991b7966685dee3a00bc873631391ed949513a"
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

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/76/f3/95b0f40b31df41dbfe6bb0857419c9442c15839cbac4796f1c26ae0b6081/pybind11-3.1.0.tar.gz"
    sha256 "a1cc06b524ab3edca51f8ad3895f9c4fa20b8b19283173dff4ae781449dc9639"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cc/a9/546676f25e573a4cf00fe8e119b78a37b6a8fe2dc95cda877b30889c9c45/regex-2025.11.3.tar.gz"
    sha256 "1fedc720f9bb2494ce31a58a1631f9c82df6a09b49c19517ea5cc280b4541e01"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/45/06/f955dbbb1859e3bd23c8ac6141af5106e7ad5fedec4a3a6e3d60f94b7001/safetensors-0.8.0.tar.gz"
    sha256 "fabaf3e0f18a6618d9b36560682562157f77c2b71fcffc7b432be2baed9d753d"
  end

  resource "scikit-build-core" do
    url "https://files.pythonhosted.org/packages/b2/1a/8c00b19c0a1e7acf890676af2efa430339d38e59fa9437f2aab8517af3f4/scikit_build_core-1.1.1.tar.gz"
    sha256 "e347a59193c878ac56a363e57506938652a6dd8c965790cb1cbc6bc7e8d5abad"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/d2/eb/eaf5e07fcc0da7149b0e084f24e54edd7441b9a89ce7e034032ae97fe3a0/scikit_learn-1.9.1.tar.gz"
    sha256 "629cada3e33e2b9bf376cdc7614a47a4140b8aedc1d836579e359736fbd82977"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "sentence-transformers" do
    url "https://files.pythonhosted.org/packages/f9/56/d2cb00765a6b15c994a7fccf20f9032f16e8193ca49147cb5155166ad744/sentence_transformers-5.6.0.tar.gz"
    sha256 "0e7164d051e416c1853ade7c274ff52af3f9da0f4be7f0b83d734c27699e1057"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/7b/b1/19587742aad604f1988a8a362e660e8c3ac03adccdb71c96d86526e5eb62/setuptools_scm-9.2.2.tar.gz"
    sha256 "1c674ab4665686a0887d7e24c03ab25f24201c213e82ea689d2f3e169ef7ef57"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "skops" do
    url "https://files.pythonhosted.org/packages/b5/0c/5ec987633e077dd0076178ea6ade2d6e57780b34afea0b497fb507d7a1ed/skops-0.13.0.tar.gz"
    sha256 "66949fd3c95cbb5c80270fbe40293c0fe1e46cb4a921860e42584dd9c20ebeb1"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/be/f9/5e4491e5ccf42f5d9cfc663741d261b3e6e1683ae7812114e7636409fcc6/sqlalchemy-2.0.45.tar.gz"
    sha256 "1632a4bda8d2d25703fdad6363058d882541bdaaee0e5e3ddfa0cd3229efce88"
  end

  resource "sqlite-dist" do
    url "https://github.com/asg017/sqlite-dist/archive/1eed44c38fadf03dd16d9c6e30ec3fafb149a5fc.tar.gz"
    version "0.0.1-alpha.22"
    sha256 "ff6b7ee403ed74414d93ef7ffbfdb424c0cf27f2896dd940324c9cc1ce26fad2"
  end

  resource "sqlite-vec" do
    url "https://github.com/asg017/sqlite-vec/archive/e9f598abfa0c06b328d8fe5da9c3760cce74be10.tar.gz"
    version "0.1.9"
    sha256 "ee2eb0be751c02286d5a6c6c113dd9e754f0ac29973b01aba35a2d736e35ed3b"
  end

  resource "sqlite-vec-amalgamation" do
    url "https://github.com/asg017/sqlite-vec/releases/download/v0.1.9/sqlite-vec-0.1.9-amalgamation.tar.gz"
    sha256 "3acd67cb4aff080c7050926fd3cf8227905fe5b7ee3829d8ee5024ab1283cf61"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/62/08/8f554b0e5bad3e4e880521a1686d96c05198471eed860b0eb89b57ea3636/sse_starlette-3.1.1.tar.gz"
    sha256 "bffa531420c1793ab224f63648c059bcadc412bf9fdb1301ac8de1cf9a67b7fb"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "staticvectors" do
    url "https://files.pythonhosted.org/packages/75/ca/8530a45deee3b60217ab64f05eef6e22babe7bd0dcebacf9cc7f3f8542a4/staticvectors-0.2.0.tar.gz"
    sha256 "8b8a558d861b39e5c4d543dff3d55573dcbd0c00c5a44b5771a5605d5799b5b7"
  end

  resource "swig" do
    url "https://files.pythonhosted.org/packages/36/34/207f6fd660986fc141e8b16a02be0704ed11078502d41e13ec09ba20baf8/swig-4.3.1.post0.tar.gz"
    sha256 "cf078be96f3293fe80df2e2b5b1b36bd6ad6eb3dbc50c0c08d9d8a67c2ea3ba0"
  end

  resource "swig-pcre2" do
    url "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.45/pcre2-10.45.zip"
    sha256 "59c8556fd45e68599897cd5d74efad9c4a43f85e981fe7ac3ac5fd7aa70672ac"
  end

  resource "swig-source" do
    url "https://github.com/swig/swig/archive/refs/tags/v4.3.1.tar.gz"
    sha256 "c6091ef5f2e397945a66899bf6859845f35ef603340e79c086d7f2ecf348678c"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "text2digits" do
    url "https://files.pythonhosted.org/packages/22/75/5aa8061cb3014802095e3defbe992b23e5ccbe200f86d15db6bcc9927b3d/text2digits-0.1.0.tar.gz"
    sha256 "a01d8dc8d57179d888ba589df40e02730f3bf2dd892ab22c37538e4799728bb2"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/b7/4d/08c89e34946fce2aec4fbb45c9016efd5f4d7f24af8e5d93296e935631d8/threadpoolctl-3.6.0.tar.gz"
    sha256 "8ab8b4aa3491d812b623328249fab5302a68d2d71745c8a4c719a2fcaba9f44e"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/7d/ab/4d017d0f76ec3171d469d80fc03dfbb4e48a4bcaddaa831b31d526f05edc/tiktoken-0.12.0.tar.gz"
    sha256 "b18ba7ee2b093863978fcb14f74b3707cdc8d4d4d3836853ce7ec60772139931"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/e0/7c/2cabb2174e772636683008f2c5621949b645da7d303c596589e84516a184/tokenizers-0.23.3.tar.gz"
    sha256 "cded33237c77caeef62944d32aa9a7ef42bdce2b3497e18d137e072a8c4be438"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/52/ed/3f73f72945444548f33eba9a87fc7a6e969915e7b1acc8260b30e1f76a2f/tomli-2.3.0.tar.gz"
    sha256 "64be704a875d2a59753d80ee8a533c3fe183e3f06807ff7dc2232938ccb01549"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "torch" do
    url "https://github.com/pytorch/pytorch/releases/download/v2.15.0/pytorch-v2.15.0.tar.gz"
    sha256 "d0688c9feb1139c6304675c41f4c5fbb8e5b084f19a83d9f95ddcb10ced9e3e7"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/42/54/b040ac523bad74f303d032505e3464cf4794f9d51defc8981ec66001936e/transformers-5.22.2.tar.gz"
    sha256 "55f57e5cbd7c0b500b7a706daa0ecd76567b56ca139e6e02ef0bba0437e3a763"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "txtai" do
    url "https://files.pythonhosted.org/packages/d1/91/c922f227f56f378fc75fe5f868d1f57a8cf7495202383e394e4cb13836c5/txtai-9.3.0.tar.gz"
    sha256 "6202c4d3f532d3167df8e6a0ac142d7fcf8160223f489ac3996e6f4820d18868"
  end

  resource "txtmarker" do
    url "https://files.pythonhosted.org/packages/20/e5/b2d638be7575b10620dc06816fe68707c9c4aad6da462f23ffb443453cd1/txtmarker-1.1.0.tar.gz"
    sha256 "eeba11e6835a0a2ad6073dba5816f338f4136f6c9773e27a818e8c3d7591b05a"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/85/30/ff9ede605e3bd086b4dd842499814e128500621f7951ca1e5ce84bbf61b1/typer-0.21.0.tar.gz"
    sha256 "c87c0d2b6eee3b49c5c64649ec92425492c14488096dfbc8a0c2799b2f6f9c53"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/ff/50/0195198eb1d75bab716bb0a813abea4cc394bfa17a92a189f021a34859af/typing_inspection-0.4.5.tar.gz"
    sha256 "7f16c411e7930dc79596d42ab44672a3fe5f60eb34b781a1647e7872363120c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uv-build" do
    url "https://github.com/astral-sh/uv/archive/refs/tags/0.11.33.tar.gz"
    sha256 "81911281e0f2fe5307c0b85e884f47cb6ca867932fb61871d339854edf3b4dcc"
  end

  resource "uv-dynamic-versioning" do
    url "https://files.pythonhosted.org/packages/6f/c8/fa500ee29af69cfeeea5ff6d6597919f1989b2e3f1a236c3006bdb21d320/uv_dynamic_versioning-0.14.1.tar.gz"
    sha256 "8642db686ce5c50417035e7a257ac73b7e5c3a7a32c33e45bd7e36ba22eeb648"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c3/d1/8f3c683c9561a4e6689dd3b1d345c815f10f86acd044ee1fb9a4dcd0b8c5/uvicorn-0.40.0.tar.gz"
    sha256 "839676675e87e73694518b5574fd0f24c9d97b46bea16df7b8c05ea1a51071ea"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  deny_network_access!

  def fetch
    cargo = formula_opt_bin("rust")/"cargo"
    with_env(CARGO_HOME:  HOMEBREW_CACHE/"paperai-cargo",
             RUSTUP_HOME: HOMEBREW_CACHE/"paperai-rustup",
             RUSTC:       formula_opt_bin("rust")/"rustc") do
      %w[build-maturin-1.15.0 fastuuid jiter sqlite-dist uv-build].each do |name|
        resource(name).stage { system cargo, "fetch", "--locked" }
      end
      resource("hf-xet").stage do
        system cargo, "fetch", "--locked", "--manifest-path", "hf_xet/Cargo.toml"
      end
      resource("litellm").stage do
        system cargo, "fetch", "--locked", "--manifest-path", "litellm-rust/Cargo.toml"
      end
      %w[safetensors tokenizers].each do |name|
        resource(name).stage do
          system cargo, "fetch", "--locked", "--manifest-path", "bindings/python/Cargo.toml"
        end
      end
      # The original tiktoken sdist has no Cargo.lock.
      resource("tiktoken").stage { system cargo, "fetch" }
    end
  end

  def install
    # Faiss and the patched LiteLLM SDK require Python <3.15. Build the matching
    # Python extension against Core's C++ libtorch, never its Python 3.15 extension.
    odie "The torch source must match Core's libtorch version" if
      resource("torch").version != Formula["pytorch"].version

    build_python = formula_opt_bin("python@3.14")/"python3.14"
    cargo = formula_opt_bin("rust")/"cargo"
    ENV.prepend_path "PATH", formula_opt_bin("rust")
    ENV.append_path "PYTHONPATH", formula_opt_prefix("maturin")/Language::Python.site_packages("python3.14")
    ENV["CARGO_HOME"] = HOMEBREW_CACHE/"paperai-cargo"
    ENV["RUSTUP_HOME"] = HOMEBREW_CACHE/"paperai-rustup"
    ENV["RUSTC"] = formula_opt_bin("rust")/"rustc"
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["NO_CYTHON_COMPILE"] = "true"
    ENV["PYYAML_FORCE_LIBYAML"] = "1"
    ENV["HNSWLIB_NO_NATIVE"] = "1"
    ENV.append "CPPFLAGS", "-I#{formula_opt_include("libyaml")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("libyaml")}"

    # The helper adds interpreter-matched Core bindings through homebrew_deps.pth even without global site packages.
    venv = virtualenv_create(libexec, build_python, system_site_packages: false)
    ENV.prepend_path "PATH", libexec/"bin"
    ENV["PYO3_PYTHON"] = libexec/"bin/python"
    ENV["MATURIN_PYTHON"] = libexec/"bin/python"
    build_resources = %w[
      flit-core wheel setuptools setuptools-scm pluggy poetry-core tomlkit
      calver trove-classifiers pathspec hatchling hatch-fancy-pypi-readme hatch-vcs expandvars
      semantic-version setuptools-rust markupsafe jinja2 dunamai pdm-backend pkgconfig
      pyproject-metadata meson meson-python cython tomli scikit-build-core pybind11 uv-dynamic-versioning
      pyyaml six typing-extensions
    ].map { |name| resource(name) }
    build_resources.each { |r| venv.pip_install r, build_isolation: false }
    replace_sdk = lambda do |name, key|
      system build_python, "-m", "pip", "--python", libexec/"bin/python", "uninstall", "-y", name
      venv.pip_install resource(key), build_isolation: false
    end
    # This licensing plugin is required only by these two original source backends.
    venv.pip_install resource("coherent-licensed"), build_isolation: false
    %w[importlib-metadata zipp].each { |name| venv.pip_install resource(name), build_isolation: false }
    system build_python, "-m", "pip", "--python", libexec/"bin/python", "uninstall", "-y", "coherent-licensed"
    resource("uv-build").stage do
      cd("crates/uv-build") { venv.pip_install Pathname.pwd, build_isolation: false }
    end

    # Keep the upstream SWIG distribution and its genuine native SDK. Route its
    # unchanged ExternalProjects to checksum-verified source archives for offline builds.
    resource("swig").stage do
      inreplace "CMakeLists.txt",
                'URL "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.45/pcre2-10.45.zip"',
                "URL \"#{resource("swig-pcre2").cached_download}\""
      inreplace "CMakeLists.txt",
                'URL "https://github.com/swig/swig/archive/refs/tags/v${SWIG_VERSION}.tar.gz"',
                "URL \"#{resource("swig-source").cached_download}\"\n      " \
                "URL_HASH \"SHA256=#{resource("swig-source").checksum}\""
      venv.pip_install Pathname.pwd, build_isolation: false
    end
    system libexec/"bin/swig", "-version"
    system formula_opt_bin("rust")/"rustc", "--version"
    system formula_opt_bin("maturin")/"maturin", "--version"

    # Older source declarations require pkg_resources and setuptools-scm <4.
    # Replace and restore both actual SDKs rather than shadowing duplicate dist-info.
    replace_sdk.call "setuptools", "build-setuptools-80.9.0"
    replace_sdk.call "setuptools-scm", "build-setuptools-scm-3.5.0"
    %w[charset-normalizer pdf-annotate python-dateutil].each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    replace_sdk.call "setuptools-scm", "setuptools-scm"
    replace_sdk.call "setuptools", "setuptools"

    # LiteLLM requires exactly Maturin 1.15.0, while jiter requires >=1.16.
    # Keep Core's newer module out of this source role and remove the older SDK afterwards.
    with_env(PYTHONPATH: nil) do
      venv.pip_install resource("build-maturin-1.15.0"), build_isolation: false
      system libexec/"bin/maturin", "--version"
      # Superenv must preserve AWS-LC's required unoptimized jitterentropy compilation.
      ENV.O0 { venv.pip_install resource("litellm"), build_isolation: false }
      system build_python, "-m", "pip", "--python", libexec/"bin/python", "uninstall", "-y", "maturin"
    end

    resource("torch").stage do
      torch_env = {
        "ATEN_NO_TEST"             => "ON",
        "BLAS"                     => "OpenBLAS",
        "BUILD_CUSTOM_PROTOBUF"    => "OFF",
        "BUILD_LIBTORCHLESS"       => "ON",
        "BUILD_PYTHON"             => "ON",
        "BUILD_TEST"               => "OFF",
        "LIBTORCH_LIB_PATH"        => formula_opt_lib("pytorch"),
        "OpenBLAS_HOME"            => formula_opt_prefix("openblas"),
        "PYTHON_EXECUTABLE"        => libexec/"bin/python",
        "PYTORCH_BUILD_NUMBER"     => "1",
        "PYTORCH_BUILD_VERSION"    => resource("torch").version.to_s,
        "USE_CCACHE"               => "OFF",
        "USE_CUDA"                 => "OFF",
        "USE_DISTRIBUTED"          => "ON",
        "USE_KLEIDIAI"             => "OFF",
        "USE_MKLDNN"               => "OFF",
        "USE_NNPACK"               => "OFF",
        "USE_OPENMP"               => "ON",
        "USE_SYSTEM_EIGEN_INSTALL" => "ON",
        "USE_SYSTEM_ONNX"          => "ON",
        "USE_SYSTEM_PYBIND11"      => "ON",
        "USE_SYSTEM_SLEEF"         => "ON",
      }
      torch_env["USE_MPS"] = "ON" if OS.mac?
      # Absolute libtorch inputs have no CMake target interface to propagate c10 to libshm on Darwin.
      torch_env["LDFLAGS"] = "#{ENV["LDFLAGS"]} #{formula_opt_lib("pytorch")}/libc10.dylib" if OS.mac?
      torch_env["BUILD_IGNORE_SVE_UNAVAILABLE"] = "1" if OS.linux? && Hardware::CPU.arm64?
      # Match Core's native feature configuration and avoid bundling its OpenMP runtime.
      inreplace "cmake/PostBuildSteps.cmake",
                "if(APPLE AND BUILD_PYTHON AND USE_OPENMP AND OpenMP_FOUND)", "if(FALSE)"
      inreplace "caffe2/core/macros.h.in", "${CMAKE_CXX_COMPILER}", ENV.cxx
      with_env(torch_env) { venv.pip_install Pathname.pwd, build_isolation: false }
    end
    torch_lib = venv.site_packages/"torch/lib"
    formula_opt_lib("pytorch").children.each do |library|
      next if library.basename.to_s.include?("torch_python") || (torch_lib/library.basename).exist?

      torch_lib.install_symlink library
    end

    resource("faiss-cpu").stage do
      # Homebrew's ccache shim is detected even when ccache is not installed.
      inreplace "cmake/default_config.cmake", "find_program(CCACHE_FOUND ccache)", "set(CCACHE_FOUND OFF)"
      venv.pip_install Pathname.pwd, build_isolation: false
    end
    resource("fasttext-wheel").stage do
      # fasttext-wheel 0.9.2 uses uint64_t without including cstdint.
      inreplace "src/args.cc", "#include <stdexcept>", "#include <stdexcept>\n#include <cstdint>"
      venv.pip_install Pathname.pwd, build_isolation: false
    end
    %w[ggml-py llama-cpp-python].each do |name|
      package = (name == "ggml-py") ? "ggml" : "llama_cpp"
      rpath = OS.mac? ? "@loader_path" : "$ORIGIN"
      # Keep the two different GGML builds isolated and relocate every shared target, including llama-common.
      with_env(CMAKE_ARGS: "-DGGML_NATIVE=OFF -DGGML_CCACHE=OFF -DGGML_BLAS=ON " \
                           "-DGGML_BLAS_VENDOR=OpenBLAS -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"} " \
                           "-DCMAKE_INSTALL_LIBDIR=#{package}/lib -DCMAKE_INSTALL_RPATH=#{rpath}") do
        venv.pip_install resource(name), build_isolation: false
      end
    end

    # HF-Xet has the same upstream entropy requirement; restore optimization outside this source role.
    ENV.O0 { venv.pip_install resource("hf-xet"), build_isolation: false }

    resource("tokenizers").stage do
      # The sdist frontend is above the binding's genuine Cargo target configuration.
      cp_r "bindings/python/.cargo", "."
      venv.pip_install Pathname.pwd, build_isolation: false
    end

    # Use sqlite-vec's own release generator over the locally compiled extension.
    # Its published Python wheels have no sdist; no downloaded binary or synthetic metadata is used.
    sqlite_dist = buildpath/"sqlite-dist-bin"
    resource("sqlite-dist").stage do
      system cargo, "build", "--release", "--locked"
      sqlite_dist.install "target/release/sqlite-dist"
    end
    resource("sqlite-vec").stage do
      extension_root = Pathname.pwd
      resource("sqlite-vec-amalgamation").stage { extension_root.install "sqlite-vec.h" }
      platform = "#{OS.mac? ? "macos" : "linux"}-#{Hardware::CPU.arm64? ? "aarch64" : "x86_64"}"
      prefix = "dist/#{platform}"
      cflags = "#{ENV.cflags} -I#{formula_opt_include("sqlite")}"
      cflags += if OS.mac?
        Hardware::CPU.arm64? ? " -mcpu=apple-m1 -DSQLITE_VEC_ENABLE_NEON" : " -mavx -DSQLITE_VEC_ENABLE_AVX"
      else
        " -lm"
      end
      system "make", "loadable", "static", "#{prefix}/sqlite-vec.h", "prefix=#{prefix}", "CFLAGS=#{cflags}"
      system sqlite_dist/"sqlite-dist", "build", "--set-version", "0.1.9"
      wheel = Dir[".sqlite-dist/pip/sqlite_vec-0.1.9-*.whl"].fetch(0)
      venv.pip_install Pathname(wheel), build_isolation: false
    end

    special = %w[
      build-maturin-1.15.0 build-setuptools-80.9.0 build-setuptools-scm-3.5.0 charset-normalizer
      coherent-licensed faiss-cpu fasttext-wheel ggml-py hf-xet importlib-metadata litellm llama-cpp-python
      pdf-annotate python-dateutil zipp
      sqlite-dist sqlite-vec sqlite-vec-amalgamation swig swig-pcre2 swig-source tokenizers torch uv-build
    ].map { |name| resource(name) }
    venv.pip_install resources - build_resources - special, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false

    # Used build-only generators/backends are not part of Paperai's runtime dependency surface.
    system build_python, "-m", "pip", "--python", libexec/"bin/python", "uninstall", "-y", "swig", "uv-build"
  end

  test do
    assert_path_exists bin/"paperai"
    ENV["PIP_DISABLE_PIP_VERSION_CHECK"] = "1"
    ENV["TORCH_DEVICE_BACKEND_AUTOLOAD"] = "0"
    (testpath/"task.yml").write <<~YAML
      name: Owned configuration
      options:
        format: markdown
      example:
        columns:
          - title
          - [section, count]
    YAML
    system libexec/"bin/python", "-B", "-c", <<~PYTHON
      import ctypes
      import importlib.metadata
      import sqlite3
      from pathlib import Path

      import faiss
      import numpy as np
      import sqlite_vec
      import torch
      import yaml
      from packaging.markers import default_environment
      from packaging.requirements import Requirement
      from paperai.report.task import Task

      path = Path("#{testpath}/task.yml")
      name, options, queries, outdir = Task.load(str(path))
      assert name == "Owned configuration"
      assert options == {"format": "markdown"}
      assert queries == [("example", {"columns": ["title", "section", "count"]})]
      assert Path(outdir) == path.parent
      assert yaml.__with_libyaml__
      assert yaml.load(path.read_text(), Loader=yaml.CSafeLoader)["name"] == name

      # pip check does not retain requested extras; also verify the original required feature closure.
      for parent, extras in (("paperai", ("",)), ("txtai", ("api", "similarity")), ("staticvectors", ("train",))):
          for requirement in importlib.metadata.requires(parent) or ():
              requirement = Requirement(requirement)
              if requirement.marker and not any(
                  requirement.marker.evaluate(dict(default_environment(), extra=extra)) for extra in extras
              ):
                  continue
              assert requirement.specifier.contains(importlib.metadata.version(requirement.name)), requirement

      values = torch.tensor([1.0, 2.0], device="cpu")
      assert (values * 2).tolist() == [2.0, 4.0]
      assert "cpython-314" in torch._C.__file__
      points = np.array([[0.0, 0.0], [3.0, 4.0]], dtype=np.float32)
      index = faiss.IndexFlatL2(2)
      index.add(points)
      distances, ids = index.search(points[:1], 2)
      assert ids.tolist() == [[0, 1]]
      assert distances.tolist() == [[0.0, 25.0]]

      with sqlite3.connect(":memory:") as db:
          db.enable_load_extension(True)
          sqlite_vec.load(db)
          db.enable_load_extension(False)
          assert db.execute("select vec_distance_l2('[1,2]', '[1,5]')").fetchone() == (3.0,)

      # Exercise only each compiled base library's scalar CPU codec, not backend/device discovery.
      for distribution, package in (("ggml-py", "ggml"), ("llama-cpp-python", "llama_cpp")):
          root = importlib.metadata.distribution(distribution).locate_file(package + "/lib")
          library = ctypes.CDLL(str(next(Path(root).glob("*ggml-base.*"))))
          library.ggml_fp32_to_fp16.argtypes = [ctypes.c_float]
          library.ggml_fp32_to_fp16.restype = ctypes.c_uint16
          assert library.ggml_fp32_to_fp16(1.0) == 0x3C00
    PYTHON
    system formula_opt_bin("python@3.14")/"python3.14", "-m", "pip",
           "--python", libexec/"bin/python", "check"
  end
end
