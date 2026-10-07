class MlxVlm < Formula
  include Language::Python::Virtualenv

  desc "Run vision language models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-vlm"
  url "https://files.pythonhosted.org/packages/df/36/461e23fd3cdab42938e8c8cb4a2f18ea7be05d6f997183ab141c1106fce0/mlx_vlm-0.7.6.tar.gz"
  sha256 "8076e29bdaf98d00eeaac16b17a05bfd139e58502939648422710cef700e9546"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-vlm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "cb5d8aee5bccc12d2e1e9dfef6de20ed72768e1f33057f9333bfc47666e0a097"
    sha256 cellar: :any, arm64_sequoia: "77b5d342033e99a35ae1cd84dafcd5773822bdddf0c3362c01f8d2ed25146230"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "maturin" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build # for sentencepiece
  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "gcc"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on macos: :sonoma
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage

  pypi_packages exclude_packages: %w[certifi datasets mlx mlx-lm numpy opencv-python pillow pydantic scipy],
                extra_packages:   %w[
                  calver flit-core hatch-fancy-pypi-readme hatch-vcs hatchling pathspec pdm-backend pluggy
                  poetry-core setuptools setuptools-scm tomlkit trove-classifiers vcs-versioning wheel
                ]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
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
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/56/4f/f7c30a73127e0a8bbffe788369b8359e530b01ae06e2757936fa35bc5e6d/fastapi-0.142.2.tar.gz"
    sha256 "06366626f2e70576367714d9ab2fe8472e6c8456dba69b399f9f797ab5e92570"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/53/e4/34efcb869715cf299e47d1ac7b2624d2bcb6f2d3dffc2f0abe8417f65ab2/filelock-4.0.12.tar.gz"
    sha256 "cf42711a7ac791818b299fab0332a088c65aeeefa36290de98db92c434303b0c"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
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

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/25/2a/484d112c0d8fc5f665d7b65137ac9cdb2953c982391598c3597968a12ee7/huggingface_hub-1.33.0.tar.gz"
    sha256 "367be21a201db9523eddf8aeac7048f2602c1b308691c97640d5e72ed188007e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "llguidance" do
    url "https://files.pythonhosted.org/packages/1e/2e/3b0e13c1e01d5598708a6e7b77c55f3ae9c6c4e242a50a239f03ee800630/llguidance-1.9.1.tar.gz"
    sha256 "3ba1b37585d07f50bb73e06dca6d45c88c9d5801789c071c8ff784c9dbcc5c46"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/d8/d5/e5439dc08561f73656bfeb3340fc64ab63163e101426593d8fb9a025ff1e/miniaudio-1.71.tar.gz"
    sha256 "ff51e2887bb673e2e757752b586b3dc924d59aa5fbcae9bbc45f4a111bd3262b"
  end

  resource "mlx-audio" do
    url "https://files.pythonhosted.org/packages/cd/a6/c75b328fc1059d0a3d56cf8330e9df6745dfe8c6ec38a3c6cfef2d42ad5f/mlx_audio-0.5.8.tar.gz"
    sha256 "55a7378a4d27dddeba2d989f71f255ce70498b3f1c27928a8b1fb0baf3577d9e"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/1f/dc/e12c1fe1ed8a7b7149777127b1a0e12ce5bd5a81d97408bedc2128c260f5/opentelemetry_api-1.45.0.tar.gz"
    sha256 "711ede81773c8025c2c03dac0450bc89f3d30aea6eabcc815c570d4e35a963f7"
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
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/45/06/f955dbbb1859e3bd23c8ac6141af5106e7ad5fedec4a3a6e3d60f94b7001/safetensors-0.8.0.tar.gz"
    sha256 "fabaf3e0f18a6618d9b36560682562157f77c2b71fcffc7b432be2baed9d753d"
  end

  resource "sentencepiece" do
    url "https://files.pythonhosted.org/packages/cc/33/ea3cb3839607eb175da835244a798f797f478c5ddf0e8ecdf57ea85a4c70/sentencepiece-0.2.2.tar.gz"
    sha256 "3d2b5e824b5622038dc7b490897efe05ebbbb9e7350fc142f3ecc8789ef9bdf6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/ec/db/0c890e2d9aab9ba284021efc02e1d3aebfecab1b611762d7434602209bcf/sounddevice-0.5.6.tar.gz"
    sha256 "8ec9fbfde2e32f020b167e348f3ab3bac6625a5f15af524d790108ac7147a410"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/7b/2b/3850dc6bf7ef71b088962eba31dafc6cffd2f96e577ebb0bb316df96da3e/starlette-1.7.0.tar.gz"
    sha256 "c79f74ea63cff761804fbbfb182f1e0b440c2d07b164d24700c5a1bab5d6ff5d"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/18/1e/bc6587c5ab643b2e17776cace9070a2ae73549c86bffac9934a600bf3c31/tokenizers-0.23.2.tar.gz"
    sha256 "7f0f085686b9de0d0079e6f874ae053600db64c5d13049e0bbc0119926d25aac"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/9e/6e/5a50ca8aff5fdd4ff21271198d2fb9e1f11bcd0ea279576199c0caa34cba/transformers-5.18.0.tar.gz"
    sha256 "d89c206e42e841af7cd314b3d2b21c03e977d819cdb4aef65ada048769a644df"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/01/89/3f825ab71c242fffb62ea8fe638741c290f62f8d7aadf8125ff897747af3/websockets-17.2.tar.gz"
    sha256 "36c2fb94c990cc2545143b12690e2de6c16300f9dbe5b4f33fa300cf57dc8792"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  deny_network_access!

  def fetch
    # maturin runs `cargo metadata`, which needs crates for every target, not only the host
    resource("hf-xet").stage { cd("hf_xet") { system "cargo", "fetch", "--locked" } }
    resource("llguidance").stage { system "cargo", "fetch", "--locked" }
    %w[safetensors tokenizers].each do |name|
      resource(name).stage { cd("bindings/python") { system "cargo", "fetch", "--locked" } }
    end
  end

  def install
    # tokenizers builds a PyO3 extension through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    build_resources = %w[
      flit-core
      packaging
      pathspec
      pdm-backend
      poetry-core
      setuptools
      calver
      cffi
      tomlkit
      trove-classifiers
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-fancy-pypi-readme
      hatch-vcs
      wheel
      pycparser
    ]

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages("python3.14")
    ENV.append_path "PYTHONPATH", formula_opt_lib("maturin")/Language::Python.site_packages("python3.14")
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r|
      build_resources.include?(r.name) || %w[hf-xet sentencepiece].include?(r.name)
    }, build_isolation: false

    resource("sentencepiece").stage do
      # Upstream hard-codes a macOS 10.9 deployment target, but its bundled abseil requires macOS 10.13 or newer.
      inreplace "setup.py", "      cflags.append('-mmacosx-version-min=10.9')\n", ""
      # The sdist already ships abseil-cpp; FetchContent_Populate would delete it and git clone it again.
      inreplace "sentencepiece/CMakeLists.txt",
                /^  include\(FetchContent\)\n  FetchContent_Populate\(abseil-cpp\n.*?\)\n/m, ""
      venv.pip_install Pathname.pwd, build_isolation: false
    end

    resource("hf-xet").stage do
      # aws-lc-sys requires jitterentropy to be compiled without optimization.
      ENV.O0
      venv.pip_install Pathname.pwd, build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false

    mlx_lm_site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("mlx-lm")/mlx_lm_site_packages}')\n"
    (venv.site_packages/"homebrew-mlx-lm.pth").write pth_contents

    unsupported_bins = [bin/"mlx_vlm.chat_ui", libexec/"bin/mlx_vlm.chat_ui"].select(&:exist?)
    rm unsupported_bins unless unsupported_bins.empty?
  end

  test do
    require "open3"

    output, status = Open3.capture2e(bin/"mlx_vlm.generate", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output

    (testpath/"test.py").write <<~PYTHON
      import importlib.util
      import pathlib
      from importlib.metadata import version
      import requests

      module_path = pathlib.Path("#{libexec}") / "lib/python3.14/site-packages/mlx_vlm/prompt_utils.py"
      spec = importlib.util.spec_from_file_location("mlx_vlm_prompt_utils", module_path)
      prompt_utils = importlib.util.module_from_spec(spec)
      spec.loader.exec_module(prompt_utils)

      assert version("mlx-vlm") == "#{version}"
      assert version("requests") == "2.34.2"
      content = [
        {"type": "text", "text": "Describe this image"},
        {"type": "image_url", "image_url": {"url": "https://example.com/image.png"}},
      ]
      assert prompt_utils.extract_text_from_content(content) == "Describe this image"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
