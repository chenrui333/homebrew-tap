class Gita < Formula
  include Language::Python::Virtualenv

  desc "Manage many git repos with sanity"
  homepage "https://github.com/nosarthur/gita"
  url "https://files.pythonhosted.org/packages/1d/89/8dd6dd79eadd70ff2f64b79f434637e384cd0490c2a626074e2a73c8a896/gita-0.16.8.2.tar.gz"
  sha256 "064e5cbcfa5df76409cfd8e70142f8153f6ecc40fb35d3a28a0a04054d5fb3fd"
  license "MIT"
  revision 1
  head "https://github.com/nosarthur/gita.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8209f4d077a24e81ba468d10a7794b77fae23d2743c8e078484f3684ecf7e607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8209f4d077a24e81ba468d10a7794b77fae23d2743c8e078484f3684ecf7e607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8209f4d077a24e81ba468d10a7794b77fae23d2743c8e078484f3684ecf7e607"
    sha256 cellar: :any_skip_relocation, sequoia:       "cc0c0931a9798dadf35b1c76e3d459595f24660b9ba899103bd7fd006bbd1142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0c0931a9798dadf35b1c76e3d459595f24660b9ba899103bd7fd006bbd1142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc0c0931a9798dadf35b1c76e3d459595f24660b9ba899103bd7fd006bbd1142"
  end

  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    calver flit-core<4 hatch-vcs hatchling packaging>=26.2 pathspec pluggy setuptools setuptools-scm
    trove-classifiers vcs-versioning
  ]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  deny_network_access!

  def install
    build_resources = %w[
      setuptools
      flit-core
      calver
      packaging
      pathspec
      pluggy
      trove-classifiers
      vcs-versioning
      setuptools-scm
      hatchling
      hatch-vcs
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |resource| build_resources.include?(resource.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gita --version")

    %w[repo1 repo2].each do |repo|
      mkdir repo do
        system "git", "init", "--initial-branch=main"
      end
    end

    # register repos
    system bin/"gita", "add", "repo1", "repo2"
    # create a group
    system bin/"gita", "group", "add", "-n", "my-group", "repo1", "repo2"

    output = shell_output("#{bin}/gita ll my-group")
    assert_match "repo1", output
    assert_match "repo2", output
  end
end
