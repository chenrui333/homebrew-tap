class Ifstate < Formula
  include Language::Python::Virtualenv

  desc "Manage host interface settings in a declarative manner"
  homepage "https://ifstate.net"
  url "https://codeberg.org/liske/ifstate/archive/2.5.0-pre1.tar.gz"
  sha256 "cda141b195d93916c2861b90ad8ba756347fb7fe91ad3303a9210334d6e33fd8"
  license "MIT"
  head "https://codeberg.org/liske/ifstate.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "4ce47515219b4c0464db404c8bfba0063b20aa4dba381f1f8ff70bf15850d6dc"
    sha256 cellar: :any, x86_64_linux: "8cf47d57e27a6b4882c0868deafa1c2aff94de9bf8c6732e5797fdbddf47e673"
  end

  depends_on "cython" => :build
  depends_on "maturin" => :build # for uv-build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on :linux
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: "rpds-py",
                extra_packages:   %w[
                  calver flit-core hatch-fancy-pypi-readme hatch-vcs hatchling packaging pathspec pluggy poetry-core
                  setuptools setuptools-scm tomlkit trove-classifiers uv-build vcs-versioning wheel
                ]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
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

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
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
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pyroute2" do
    url "https://files.pythonhosted.org/packages/1d/b2/1019ddc278549fb7e64a16d7775e0f7d981135f762b8706e583414d655e3/pyroute2-0.9.5.tar.gz"
    sha256 "a198ccbe545b031b00b10da4b44df33d548db04af944be8107c05a215ba03872"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "uv-build" do
    url "https://files.pythonhosted.org/packages/b4/65/672d5c1e7fff2a602b51758cd96c379ea80c0c20d9d10aae5139bfde9877/uv_build-0.12.23.tar.gz"
    sha256 "b0428317e2783252b33b513446436071f4e14bfeb38655c99877ca6550ea4aac"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
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
      flit-core
      packaging
      pathspec
      poetry-core
      setuptools
      calver
      tomlkit
      trove-classifiers
      uv-build
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-fancy-pypi-readme
      hatch-vcs
      wheel
    ]

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages("python3.14")
    ENV.append_path "PYTHONPATH", formula_opt_lib("maturin")/Language::Python.site_packages("python3.14")
    ENV.prepend_path "PATH", libexec/"bin"
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    # ifstatecli omits the prerelease suffix in its version output.
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ifstatecli --version")

    (testpath/"ifstate.yaml").write <<~YAML
      interfaces: {}
      bogus: true
    YAML
    output = shell_output("#{bin}/ifstatecli -c #{testpath}/ifstate.yaml validate 2>&1", 4)
    assert_match "Config validation failed", output
    assert_match "'bogus' was unexpected", output
  end
end
