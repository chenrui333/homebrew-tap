class ReformatGherkin < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Gherkin language"
  homepage "https://github.com/ducminh-phan/reformat-gherkin"
  url "https://files.pythonhosted.org/packages/7c/66/6da6919eb32a12e73b7af0fe4f82feb98a2280de9783a17d488cf4bb1bc6/reformat-gherkin-3.0.1.tar.gz"
  sha256 "a25e89fac3b632a7db7a3f217f4bfdc0f9cf4d8333d3ae9a830b0270beba6f3b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b86a19115c0beb48514c929cca12b699e1dd7088202c41903716bef074ef7ce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99a305373ddce511f93c4b27dbf70bd9db5d094789efc2c33cd8ec22d7a57e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b179416b1392f5952c0ab4d0ed6d68438fc6e8d9ffa9f5de0553a1ae3f0083c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb570c3c0d42ccb6f4ac2fff1331441b294446d5d95913f58c714ce37bfb67c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6fc7ca952190d890a6b4fdb12d94ad7e0ca350288226bbc2a56e4a583e895c"
  end

  depends_on "cython" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    calver flit-core hatch-fancy-pypi-readme hatch-vcs hatchling packaging pathspec pluggy poetry-core setuptools
    setuptools-scm tomlkit trove-classifiers vcs-versioning
  ]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/f7/06/9d81ad262e0146c0f2e94c6c450f6c4c490ce2e4711f30e546bb04883b62/cattrs-22.1.0.tar.gz"
    sha256 "94b67b64cf92c994f8784c40c082177dc916e0489a73a9a36b24eb18a9db40c6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "gherkin-official" do
    url "https://files.pythonhosted.org/packages/64/18/02ae1bc046028781711f39a26e5ead8ec4e636be01e22918870f6a6bbfb4/gherkin-official-24.0.0.tar.gz"
    sha256 "c126de30ac2a2262967ddde83912511267fa76be4883418974f529292e76c415"
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

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  deny_network_access!

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
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-fancy-pypi-readme
      hatch-vcs
    ]

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages("python3.14")

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false

    generate_completions_from_executable(bin/"reformat-gherkin", shells:                 [:fish, :zsh],
                                                                 shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reformat-gherkin --version")

    (testpath/"test.feature").write <<~FEATURE
      Feature: Test feature
        Scenario: Test scenario
          Given a step
          When another step
          Then a final step
    FEATURE

    assert_match <<~EOS, shell_output("#{bin}/reformat-gherkin --check test.feature 2>&1", 1)
      Would reformat #{testpath}/test.feature
      All done! 💥 💔 💥
      1 file would be reformatted.
    EOS

    assert_match <<~EOS, shell_output("#{bin}/reformat-gherkin test.feature 2>&1")
      Reformatted #{testpath}/test.feature
      All done! ✨ 🍰 ✨
      1 file reformatted.
    EOS

    expected_content = <<~FEATURE
      Feature: Test feature

        Scenario: Test scenario
          Given a step
          When another step
          Then a final step
    FEATURE

    assert_equal expected_content, (testpath/"test.feature").read
  end
end
