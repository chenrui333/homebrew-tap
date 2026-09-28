class Asmdiff < Formula
  include Language::Python::Virtualenv

  desc "Compare per-function assembly across compilers"
  homepage "https://github.com/rt-rtos/asmdiff"
  url "https://files.pythonhosted.org/packages/79/93/b634871bebc2db8f2fc59baf04a78356b13dab510fe8fe5c9a8aff3e0a49/asmdiff-0.4.0.tar.gz"
  sha256 "147454fd2367fe1a827a15d3987bd56f17f897a48a3ad66e2b6108e9e32ccd85"
  license "MIT"
  head "https://github.com/rt-rtos/asmdiff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0e49185dfe7e535e3c0c77de8be77add2ff9a00bbc3a43d8f84d9283e0a93e7c"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.14"

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
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

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/3c/87/1ff7adcf6e03021ae58ce401565be3c9b8c739a44d14a8253d38b3754117/setuptools_scm-10.2.3.tar.gz"
    sha256 "f179ed3e2a63cf5823e5ee9aa9ca08386219400443a0553224d72dde3f206b44"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/c2/e3/7ca82ee24c82d344584abd5b8637b3bd056f2900226e8d82fc22f1184b92/trove_classifiers-2026.6.1.19.tar.gz"
    sha256 "c5132b4b61a829d11cfbd2d72e97f20a45ed6edb95e45c5efdeb5e00836b2745"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/3e/97/792a4ef20344f9af3e16098b58b45eb5d6202259b84fc80c43bc000a5e6c/vcs_versioning-2.4.1.tar.gz"
    sha256 "d4575de3115ec9434393c87c80ffb0eb98a16056bfe2b11ce0f3a97aff67fe0a"
  end

  deny_network_access!

  def install
    build_resources = %w[
      calver
      flit-core
      packaging
      pathspec
      poetry-core
      tomlkit
      trove-classifiers
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asmdiff --version")
    (testpath/"test.c").write "int add(int x) { return x + 1; }\n"
    output = shell_output("#{bin}/asmdiff test.c --cc '#{ENV.cc} -O2' --filter 'add$' --json")
    assert_match(/"_?add"/, output)
  end
end
