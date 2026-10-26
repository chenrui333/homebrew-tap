class Gitlabform < Formula
  include Language::Python::Virtualenv

  desc "Specialized configuration as a code tool for GitLab"
  homepage "https://gitlabform.github.io/gitlabform/"
  url "https://files.pythonhosted.org/packages/17/70/359958fc731ced96167b91cc18b15c8f0bc3e69f8642be040a75ec982071/gitlabform-6.3.1.tar.gz"
  sha256 "0189c014455170c29c4c8c79081994dcf30218b0a870ea26f1e3a728e229e097"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ddbf79375b3adc7cc9ef7405b07f6b6b57a74fabfe4ce61886f5d78c5223a3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4df4804a635d9acd4d578353d90accb7a5dae08493a2fbe8a54de451a939f779"
    sha256 cellar: :any,                 arm64_linux:   "4fe5c72ff9bc9c6d752d6ce0d79c85e0e8208e505b1b19637c16d8cf93e52978"
    sha256 cellar: :any,                 x86_64_linux:  "b1a80c8a0a1551dc57c40c4b4784133d71564796eb864af214a006f6694f99a9"
  end

  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "python@3.13"

  pypi_packages extra_packages: %w[
    cython expandvars flit-core hatch-fancy-pypi-readme hatch-vcs hatchling pathspec pluggy poetry-core
    setuptools setuptools-scm trove-classifiers uv-build vcs-versioning wheel
  ], exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cli-ui" do
    url "https://files.pythonhosted.org/packages/21/63/70d8fefa7b4140367c45287b94fb5df535b6ba6f77464087b18fdae2bb47/cli_ui-0.19.0.tar.gz"
    sha256 "59cdab0c6a2a6703c61b31cb75a1943076888907f015fffe15c5a8eb41a933aa"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "expandvars" do
    url "https://files.pythonhosted.org/packages/9c/64/a9d8ea289d663a44b346203a24bf798507463db1e76679eaa72ee6de1c7a/expandvars-1.1.2.tar.gz"
    sha256 "6c5822b7b756a99a356b915dd1267f52ab8a4efaa135963bd7f4bd5d368f71d7"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "gql" do
    url "https://files.pythonhosted.org/packages/85/95/15fdc8ef0b3a5333a019ad1ade6097b3251a599637e9d477e938da97a030/gql-4.4.0.tar.gz"
    sha256 "e54fe470d51347ceb46a04fc88c5553695d2d8c86b05bef13aeee8b8f2d5f61a"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/a4/91/223fbace7c8648690d7fb77855e29bd248c9ed1e0833ed3002ab29bc1441/graphql_core-3.3.1.tar.gz"
    sha256 "8d9b6f95fb66b58b260904cf9e191f422782620533ec8fa0c96ab941b6659a2a"
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

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "luddite" do
    url "https://files.pythonhosted.org/packages/9e/93/23defe449b102db8744ea89984aafb4b10df7f91ddabc73ecae07ef13a6e/luddite-1.0.4.tar.gz"
    sha256 "e05001efc80eb6c1c7514439812fbc71a66d59e031e09f9a72772f3e6cddfab7"
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

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/7b/6b/29ef8e752f5854dcc267ded0652c475bec99b86f255957a0d4fcad657b18/multidict-7.2.1.tar.gz"
    sha256 "e8af3e6f1bdbc31fd762b094133b478b89988eaebc63cbe82b1d9e3bbd15cede"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/df/f15f80383f152452d8985b36d95cb8751f901a3e0ff4cd27f7e118f168e2/python_dateutil-3.0.0.tar.gz"
    sha256 "7ebcb3c29a92f3ceafe79a7a48a5c45677e9e004bbeec5742ac0bbb00560b7a2"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/5c/dc/292d32245ca35447b265c47a0ed9f35de1ab280a05da1da306b61a035833/python_gitlab-8.6.0.tar.gz"
    sha256 "d1602164fb58ab280ceef460faf015cec6e7d83bb2d9cbae44ba448adb5568ef"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/82/9e/497c1c8ebe5a5b5d1d4a7511aea22c0bb1a97e3170d98abdef0e1b34265a/tenacity-9.2.1.tar.gz"
    sha256 "a606b5c808d0cded4a359d5b9932d867ff2a6a6b64d37350260fd01bbdf83839"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uv-build" do
    url "https://files.pythonhosted.org/packages/d3/c1/7a115ebc91b2f26155cbcea487e0fcac947dab38058e2da2503ba27412c5/uv_build-0.13.5.tar.gz"
    sha256 "c95a3d092cb8880b37f35013f9f7339f3867bc422abed36776255f34e22bc62c"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/ad/e7/2a691db7d076b75d099fdba1a14cd966931f2aeb591e77f6d22f15097326/vcs_versioning-2.6.0.tar.gz"
    sha256 "22e9159288e2d8bca2fa6f6c31c34c9c66aec157f60e9e526f5d160d2516d60f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "yamlpath" do
    url "https://files.pythonhosted.org/packages/0d/3c/28fc3fb1e64c1296bc8b3082eac745209460a584e7ee1b46a6a255f2699a/yamlpath-3.9.1.tar.gz"
    sha256 "624d69d55a9e4b7599e5e7092e6668e6406925f0e6b096965d30068bf542f542"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  deny_network_access!

  def fetch
    resource("uv-build").stage do
      # Maturin reads Cargo metadata for every target, not just the build host.
      system "cargo", "fetch", "--locked"
    end
  end

  def install
    build_resources = %w[
      setuptools
      cython
      flit-core
      poetry-core
      packaging
      vcs-versioning
      pathspec
      pluggy
      trove-classifiers
      hatchling
      setuptools-scm
      hatch-vcs
      expandvars
      hatch-fancy-pypi-readme
      wheel
      uv-build
    ]

    venv = virtualenv_create(libexec, "python3.13")
    ENV.prepend_path "PATH", libexec/"bin"
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |resource| build_resources.include?(resource.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlabform --version --skip-version-check")

    (testpath/"config.yml").write <<~YAML
      config_version: 4
      project_settings:
        "*/*":
          merge_requests_access_level: "enabled"
    YAML

    output = shell_output("#{bin}/gitlabform -c config.yml --noop ALL_DEFINED 2>&1", 1)
    assert_match "GitLab test request failed", output
  end
end
