class MlxTune < Formula
  include Language::Python::Virtualenv

  desc "Fine-tune LLMs on Apple Silicon with MLX"
  homepage "https://github.com/ARahim3/mlx-tune"
  url "https://files.pythonhosted.org/packages/d0/5a/01718660a6b8c3de4662809da9bac2c3baffddb4c04a140b0b4f6c2fe362/mlx_tune-0.4.3.tar.gz"
  sha256 "e2d23b9cb0a77b27fdf4a4da31b6b6718a69ffa2390e4ede8d29a6a4c65e483e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ARahim3/mlx-tune.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c9e0b2af3cfea1d41f91a3673cc6c6e59a04a8dcbdbabea1c3f84ed0041e59f6"
    sha256 cellar: :any, arm64_sequoia: "96d5abfd34176aa23c725636d28790eb0aed6bb7f01260e04a5f522ecd86b959"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "abseil"
  depends_on "apache-arrow"
  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libffi"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libtiff"
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "pillow"
  depends_on "protobuf"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "webp"

  on_macos do
    depends_on macos: :sonoma
  end

  # OpenCV 5.0.0.93 omits the Caffe schema needed to regenerate bindings for system protobuf.
  pypi_packages exclude_packages: %w[certifi mlx mlx-lm numpy pillow pydantic],
                extra_packages:   %w[
                  calver expandvars flit-core fsspec==2026.7.0 hatch-fancy-pypi-readme hatch-vcs hatchling libcst
                  meson meson-python opencv-python==4.14.0.94
                  packaging pathspec pdm-backend pkgconfig pluggy poetry-core pyproject-metadata scikit-build
                  scikit-build-core semantic-version setuptools setuptools-rust setuptools-scm tomlkit
                  trove-classifiers versioneer wheel
                ]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "datasets" do
    url "https://files.pythonhosted.org/packages/17/e6/b5d8c77f13cc6269660b0f2691e8875777b9d94972e281b7b2c25f25bd9d/datasets-5.1.0.tar.gz"
    sha256 "1561347daa8841b51351ef2ad1647b4ee4af406852c0f7bd1df587ac1ca7888e"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"

    # Support Python 3.15 code objects within the existing datasets/multiprocess bounds.
    patch do
      url "https://github.com/uqfoundation/dill/commit/37d2bf717ac7ac110f06be5210f989847959c2cd.patch?full_index=1"
      sha256 "4f52e168ccfec43613d38965521686d18aebd425e9b0ecec4ab90f383d69305b"
      type :backport
      resolves "https://github.com/uqfoundation/dill/pull/755"
    end
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "expandvars" do
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/e9/eb/2cf8c80abf09b2800aef0a83b41066fbfda8ee5495b7a08b9d1af40f7046/fastapi-0.162.0.tar.gz"
    sha256 "6a22c1e2e6e32e0633ee7e170f00009a29b8228b16feb219ee42f32fd8d88a8f"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
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

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/02/c0/098e5c91ff1537f00c85a6438b6cb1863d17144680cc91f47c87f104a200/libcst-1.9.0.tar.gz"
    sha256 "087b58a9afe076bb08e2d726478e1f16cb928d67ffa9092817e033c335de522a"
  end

  resource "meson" do
    url "https://files.pythonhosted.org/packages/f9/c9/8c9983f4f3d9c4e22fd76bcf8cd053e4472aefae45fd044669b6daa34b53/meson-1.12.1.tar.gz"
    sha256 "ab0a6ca09f8ef70c564c8241fb5a23957886a0b53fb58412b5e07eaf07dba743"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/b4/40/343ae23722d5d66a7b94b752d1b194202640995296379333b274b1860871/meson_python-0.22.1.tar.gz"
    sha256 "52c88628b0e5671592dc2306613fb5f6f3615fd24def059b9894f143b7f9a139"
  end

  resource "mlx-vlm" do
    url "https://files.pythonhosted.org/packages/6b/cc/04a100878abc21aac431221cc6fb79bb69f29e9e61a84284f866340dadfd/mlx_vlm-0.3.12.tar.gz"
    sha256 "b9ee7528ec2765cc02d3115b39a70f0dc1c51345473530981e6386a91f26f379"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "multiprocess" do
    url "https://files.pythonhosted.org/packages/a2/f2/e783ac7f2aeeed14e9e12801f22529cc7e6b7ab80928d6dcce4e9f00922d/multiprocess-0.70.19.tar.gz"
    sha256 "952021e0e6c55a4a9fe4cd787895b86e239a40e76802a789d6305398d3975897"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/ed/e8/c2959c0f969ea4ae96b55ad10c108c0410de4e8b3550d9941a4cfdd52703/opencv_python-4.14.0.94.tar.gz"
    sha256 "afadc76a38a07713a4c2b4702da917cf0ed489be57e2a40a34e670189731de7d"

    # Preserve hardware codec discovery with Core's FFmpeg 9.
    patch do
      url "https://github.com/opencv/opencv/commit/7551012b4e1c854c1dc36483c893f90b1c236977.patch?full_index=1"
      sha256 "0e662fbfd9949c4588138fcdb49bff124bf5e092ecfaa4db07938f50bb3ee1de"
      directory "opencv"
      type :backport
      resolves "https://github.com/opencv/opencv/pull/29533"
    end

    # Use the supported frame-rate API instead of fields removed by FFmpeg 9.
    patch do
      url "https://github.com/opencv/opencv/commit/a6f17e1f6a53f8bb016acfbcd55b61cbe220f5c8.patch?full_index=1"
      sha256 "f9fc79e1783debed6530600044c73f9a7d816c3b3095c260e1769bd04a62eb7d"
      directory "opencv"
      type :backport
      resolves "https://github.com/opencv/opencv/pull/29662"
    end
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/17/ca/24c6bc92aca3d366146358e47f1d374c0e1a50763ef226fc71eff20a63fb/pandas-3.1.1.tar.gz"
    sha256 "05fed3e3b7c99b226f160e29d7d6cb7ef39638c758cbfe42b3f24ba34f04b859"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pdm-backend" do
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
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
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/bc/5e/9cb2a56d5e293aab4e2fbecc5b0620d93227d66b8d5a63c554c31e1f80fe/pyarrow-26.0.1.tar.gz"
    sha256 "93affcbd8a343e98dc19e9ec8fe17271ebf8fe98102d8b7454175074409f8b72"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/cb/27/eeb9f307bf07060f3d9f9aa0fb8c15b01bdfded0a941e4b2719c7f94cacd/pycparser-3.12.tar.gz"
    sha256 "f03387877eab82ce01bbdfd0ba7252ee55a90b1c708d5129e2ce915475cf1db6"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "scikit-build" do
    url "https://files.pythonhosted.org/packages/c7/ce/8ec52888f74a3e849a56bfe0a6d48d93646ac95ad4ff22915639a4393ea6/scikit_build-0.19.1.tar.gz"
    sha256 "b9a8d07fca2d5d10d93220bc57a685161d72af1fc76285d55c564ddaa862e584"
  end

  resource "scikit-build-core" do
    url "https://files.pythonhosted.org/packages/30/8a/a1777e7eef0e91cc182b8a1eea3b88be6520c7b5afaf08232a7d8899c0ae/scikit_build_core-1.1.2.tar.gz"
    sha256 "7893709119c5ab1be75cd10442383132c9433b9f104dacef5185949efbea7974"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/7b/b1/19587742aad604f1988a8a362e660e8c3ac03adccdb71c96d86526e5eb62/setuptools_scm-9.2.2.tar.gz"
    sha256 "1c674ab4665686a0887d7e24c03ab25f24201c213e82ea689d2f3e169ef7ef57"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/d2/db/949331952a6fb1c5b12e9de80fd08747966c2039d1a61db4764fbd3981c2/soundfile-0.14.0.tar.gz"
    sha256 "ba1c1a2d618bca5c406647c83b89f07cc8810fa506a50622a6993ba130c1de11"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "versioneer" do
    url "https://files.pythonhosted.org/packages/32/d7/854e45d2b03e1a8ee2aa6429dd396d002ce71e5d88b77551b2fb249cb382/versioneer-0.29.tar.gz"
    sha256 "5ab283b9857211d61b53318b7c792cf68e798e765ee17c27ade9f6c924235731"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/02/84/30869e01909fb37a6cc7e18688ee8bf1e42d57e7e0777636bd47524c43c7/xxhash-3.6.0.tar.gz"
    sha256 "f0162a78b13a0d7617b2845b90c763339d1f1d82bb04a4b07f4ab535cc5e05d6"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  resource "opencv-ade" do
    url "https://github.com/opencv/ade/archive/refs/tags/v0.1.2e.tar.gz"
    sha256 "107711887d413127955d64a0e42974ec379c1ebb81832c79a21a9e3a2110e4bf"

    livecheck do
      skip "Version pinned by OpenCV's G-API backend"
    end
  end

  resource "opencv-kleidicv" do
    url "https://gitlab.arm.com/kleidi/kleidicv/-/archive/26.03/kleidicv-26.03.tar.gz"
    sha256 "1bb4078fd215565f3906c33f76a00e7b843328965230d765afcd0d51141c434f"

    livecheck do
      skip "Version pinned by OpenCV's ARM HAL"
    end
  end

  resource "opencv-setuptools" do
    url "https://github.com/pypa/setuptools/archive/refs/tags/v69.5.1.tar.gz"
    sha256 "2cf4ea407b1325c2c85862d13eb31f9b57098b0ae7f94e2258aea4e634f6534f"

    livecheck do
      skip "OpenCV's build backend requires setuptools<70"
    end
  end

  deny_network_access!

  def fetch
    resource("libcst").stage { system "cargo", "fetch", "--manifest-path", "native/Cargo.toml", "--locked" }
  end

  def install
    build_resources = %w[
      flit-core
      packaging
      pathspec
      poetry-core
      pkgconfig
      setuptools
      calver
      setuptools-scm
      pluggy
      tomlkit
      trove-classifiers
      hatchling
      expandvars
      hatch-fancy-pypi-readme
      hatch-vcs
      wheel
      pdm-backend
      distro
      scikit-build
      scikit-build-core
      meson
      pyproject-metadata
      meson-python
      versioneer
      semantic-version
      setuptools-rust
      libcst
    ]

    # Both Core MLX providers expose only Python 3.15.
    ENV.delete "PYTHONPATH"
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.15")
    ENV.prepend_path "PATH", venv.root/"bin"

    # Append Cython's build-only tree rather than letting its setuptools shadow our backends.
    cython_site_packages = formula_opt_libexec("cython")/Language::Python.site_packages("python3.15")
    cython_pth = venv.site_packages/"homebrew-cython.pth"
    cython_pth.write "import site; site.addsitedir('#{cython_site_packages}')\n"

    # Process the provider's own .pth files, while keeping our resources first on sys.path.
    mlx_lm_site_packages = Language::Python.site_packages("python3.15")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("mlx-lm")/mlx_lm_site_packages}')\n"
    (venv.site_packages/"homebrew-mlx-lm.pth").write pth_contents

    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end

    # G-API supports an external ADE package, so build its exact source without downloading a zipball.
    ade_prefix = buildpath/"opencv-ade"
    resource("opencv-ade").stage do
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17",
             *std_cmake_args(install_prefix: ade_prefix)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Core installs cv2 without opencv-python metadata. The upstream packaging backend builds
    # its own OpenCV tree; its standalone binding build needs an unavailable original build tree.
    # Preserve the real distribution, including its codecs, rather than inventing Core metadata.
    # Its setuptools<70 build role must not overwrite the modern backend or leave duplicate metadata.
    opencv_venv = virtualenv_create(buildpath/"opencv-build", "python3.15")
    tools_pth = "import site; site.addsitedir('#{venv.site_packages}')\n"
    (opencv_venv.site_packages/"homebrew-build-tools.pth").write tools_pth
    # Register wheel's legacy bdist_wheel command before bootstrapping the older setuptools source.
    opencv_venv.pip_install resource("wheel"), build_isolation: false
    opencv_venv.pip_install resource("opencv-setuptools"), build_isolation: false
    ENV["OpenBLAS_HOME"] = formula_opt_prefix("openblas")
    ENV["CMAKE_ARGS"] = %W[
      -Dade_DIR=#{ade_prefix}/share/ade
      -DCMAKE_CXX_STANDARD=17
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_OPENJPEG=OFF
      -DBUILD_PNG=OFF
      -DBUILD_PROTOBUF=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_WEBP=OFF
      -DBUILD_ZLIB=OFF
      -DPROTOBUF_UPDATE_FILES=ON
      -DWITH_FFMPEG=ON
      -DWITH_OPENEXR=ON
      -DWITH_OBSENSOR=OFF
    ].join(" ")
    opencv_wheel_dir = buildpath/"opencv-wheel"
    resource("opencv-python").stage do
      # pip configures and builds together, so clean build-info at generation time.
      # Match Core's OpenCV cleanup without changing compiler commands or audit policy.
      inreplace "opencv/cmake/OpenCVUtils.cmake", "function(ocv_output_status msg)", <<~CMAKE.chomp
        function(ocv_output_status msg)
          string(REPLACE "#{Superenv.shims_path}/" "" msg "${msg}")
      CMAKE

      # Populate OpenCV's checksum-keyed source cache before its offline CMake build.
      kleidicv_cache = Pathname.pwd/"opencv/.cache/kleidicv"
      kleidicv_cache.mkpath
      cp resource("opencv-kleidicv").cached_download,
         kleidicv_cache/"b85a745bfe0e87e67e30be9533eb6b24-kleidicv-26.03.tar.gz"
      system python3, "-m", "pip", "--python=#{opencv_venv.root}/bin/python", "wheel",
             "--verbose", "--no-deps", "--no-binary=:all:", "--no-build-isolation",
             "--wheel-dir=#{opencv_wheel_dir}", Pathname.pwd
    end
    ENV.delete "CMAKE_ARGS"
    venv.pip_install opencv_wheel_dir.glob("opencv_python-*.whl").fetch(0)
    rm_r [opencv_venv.root, opencv_wheel_dir, ade_prefix]

    special_resources = %w[opencv-ade opencv-kleidicv opencv-python opencv-setuptools pandas pyarrow]
    venv.pip_install resources.reject { |r| (build_resources + special_resources).include?(r.name) },
                     build_isolation: false

    # Both exact Meson subprojects are already vendored in the pandas sdist.
    ENV["PIP_CONFIG_SETTINGS"] = "setup-args=--wrap-mode=nodownload"
    venv.pip_install resource("pandas"), build_isolation: false
    ENV.delete "PIP_CONFIG_SETTINGS"

    # Build Python bindings against Core's Arrow C++ libraries, never bundled copies.
    ENV["Arrow_ROOT"] = formula_opt_prefix("apache-arrow")
    ENV["PYARROW_BUNDLE_ARROW_CPP"] = "OFF"
    ENV["PYARROW_WITH_ACERO"] = "ON"
    ENV["PYARROW_WITH_DATASET"] = "ON"
    ENV["PYARROW_WITH_PARQUET"] = "ON"
    venv.pip_install resource("pyarrow"), build_isolation: false
    cython_pth.unlink
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    ENV["HF_HUB_OFFLINE"] = "1"
    ENV["HF_DATASETS_OFFLINE"] = "1"

    (testpath/"test.py").write <<~PYTHON
      import sys
      from importlib.metadata import version
      from pathlib import Path
      import cv2
      import dill
      import fsspec
      import mlx.core as mx
      import multiprocess
      from multiprocess.reduction import ForkingPickler
      import numpy as np
      import pandas as pd
      import pandas._libs.interval
      import pyarrow as pa
      import pyarrow.parquet as pq

      mx.set_default_device(mx.cpu)
      from datasets import Dataset
      from mlx_tune import apply_column_mapping, detect_dataset_format, get_template_for_model
      from mlx_tune import standardize_sharegpt, to_sharegpt
      from mlx_tune.vlm import HAS_MLX_VLM

      assert sys.version_info[:2] == (3, 15)
      assert version("mlx-tune") == "#{version}"
      assert HAS_MLX_VLM
      assert version("fsspec") == "2026.7.0"
      for module in (dill, fsspec, multiprocess, pd, pa):
          assert Path(module.__file__).is_relative_to(Path("#{libexec}"))
      print(sys.executable)
      for module in (mx, np._core._multiarray_umath, pandas._libs.interval, pa.lib, cv2):
          print(module.__name__, module.__file__)
      for name in (
          "mlx", "mlx-lm", "mlx-vlm", "numpy", "pandas", "pyarrow",
          "opencv-python", "dill", "multiprocess"
      ):
          print(name, version(name))

      callback = lambda value: value + 7
      assert dill.loads(dill.dumps(callback, recurse=True))(5) == 12
      assert ForkingPickler.loads(ForkingPickler.dumps(callback, recurse=True))(5) == 12

      with mx.stream(mx.cpu):
          result = mx.array([1, 2, 3], dtype=mx.int32) + mx.array([4, 5, 6], dtype=mx.int32)
          mx.eval(result)
          assert result.tolist() == [5, 7, 9]

      values = {"instruction": ["Hello", "Second"], "output": ["World", "Answer"]}
      dataset = Dataset.from_dict({"question": values["instruction"], "answer": values["output"]})
      mapped = apply_column_mapping(dataset, {"instruction": "question", "output": "answer"})
      assert mapped.column_names == ["instruction", "output"]
      assert mapped.to_dict() == values
      assert detect_dataset_format(mapped[0]) == "alpaca"
      assert get_template_for_model("meta-llama/Llama-3.2-1B-Instruct") == "llama-3.1"

      conversations = to_sharegpt(mapped)
      assert conversations[0]["conversations"] == [
          {"from": "human", "value": "Hello"}, {"from": "gpt", "value": "World"}
      ]
      chatml = standardize_sharegpt(conversations)
      assert chatml[0]["messages"] == [
          {"role": "user", "content": "Hello"}, {"role": "assistant", "content": "World"}
      ]

      frame = mapped.to_pandas()
      assert frame.to_dict(orient="list") == values
      schema = pa.schema([("instruction", pa.string()), ("output", pa.string())])
      table = pa.Table.from_pandas(frame, schema=schema, preserve_index=False)
      pq.write_table(table, "mapped.parquet")
      restored = pq.read_table("mapped.parquet")
      assert restored.schema.equals(schema, check_metadata=False)
      assert restored.schema.equals(table.schema, check_metadata=True)
      assert restored.to_pydict() == values
      assert restored.to_pandas().to_dict(orient="list") == values

      image = np.array([[[0, 17, 255], [42, 73, 99]]], dtype=np.uint8)
      success, encoded = cv2.imencode(".png", image)
      assert success
      assert np.array_equal(cv2.imdecode(encoded, cv2.IMREAD_COLOR), image)
    PYTHON

    system libexec/"bin/python", "test.py"
    system python3, "-m", "pip", "--python=#{libexec}/bin/python", "check"
  end
end
