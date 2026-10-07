class Vsg < Formula
  include Language::Python::Virtualenv

  desc "VHDL Style Guide"
  homepage "https://github.com/jeremiah-c-leary/vhdl-style-guide"
  url "https://github.com/jeremiah-c-leary/vhdl-style-guide/archive/refs/tags/3.35.0.tar.gz"
  sha256 "243814d768d14ffa76503d63f4aa60a1c7afd3a561cbda46c0954602fcdff390"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7269d335e67e49993766211b97876dd8acaf1f8305f8757292ca8adc44c64a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69eb8aef8c7de5daef34bd0d5fb9d22969afceea10e4b9fda7879075d9980874"
    sha256 cellar: :any,                 arm64_linux:   "d1063b3ffdfc50c66dadacf5f4565c0a5154a2651cd4e922b365decd1def7b3f"
    sha256 cellar: :any,                 x86_64_linux:  "1dc7b78aaa4ad1d178fe03dcf10b35bdf1650325d5044a9469b7afb975bff21a"
  end

  depends_on "cython" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    flit-core packaging setuptools setuptools-git-versioning wheel
  ]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/e7/91/add211b38c357bf1b94900b4f79c34661a92be65c0243d2b0a3393c5092d/flit_core-4.1.0.tar.gz"
    sha256 "62e12b63ead8335b37f59fabb977c7167fe476dafb5e41785dfa8c9aff843bc6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-git-versioning" do
    url "https://files.pythonhosted.org/packages/53/8c/d315ac297c004cf15b506eb53d6b0b29e18eadfc44fde7b9b971a41f3206/setuptools_git_versioning-3.1.0.tar.gz"
    sha256 "612dfcf184addac9e1c2216f4f229724b2390e5bf613fb925ae80b84f2529172"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  # add `starting_version` to override default `0.0.1`
  # see https://github.com/dolfinus/setuptools-git-versioning/blob/master/setuptools_git_versioning.py#L33
  patch :DATA

  deny_network_access!

  def install
    # fix version
    inreplace "pyproject.toml", "3.30.0", version.to_s

    build_resources = %w[
      flit-core
      packaging
      setuptools
      wheel
      setuptools-git-versioning
    ]

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages("python3.14")

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vsg --version")

    (testpath/"test.vhdl").write <<~VHDL
      entity test is
      end entity test;
    VHDL

    assert_match <<~EOS, shell_output("#{bin}/vsg test.vhdl")
      Phase 7 of 7... Reporting
      Total Rules Checked: 889
      Total Violations:    0
        Error   :     0
        Warning :     0
    EOS

    expected_content = <<~VHDL
      entity test is
      end entity test;
    VHDL

    assert_equal expected_content, (testpath/"test.vhdl").read
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index 0f56cea..0688b6d 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -73,6 +73,7 @@ vsg = "vsg.__main__:main"
 [tool.setuptools-git-versioning]
 enabled = true
 template = "{tag}"
+starting_version = "3.30.0"

 [tool.setuptools.package-data]
 "vsg.rules" = [
