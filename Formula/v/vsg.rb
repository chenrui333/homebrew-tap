class Vsg < Formula
  include Language::Python::Virtualenv

  desc "VHDL Style Guide"
  homepage "https://github.com/jeremiah-c-leary/vhdl-style-guide"
  url "https://github.com/jeremiah-c-leary/vhdl-style-guide/archive/refs/tags/3.36.0.tar.gz"
  sha256 "155e2af19b2a2d27d305b9e6323a6acd75b5741ae1812ebd890ea9ca407e5f00"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c882901136902366c3be3399ba207a9b7f5f88683c83f9baea6f614df1fe59d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b272248ce2de5ebc6e2b51de2c32659e6695fdbd5dbd6ebdc7a9ecdccb552f"
    sha256 cellar: :any,                 arm64_linux:   "3b1e8d140766fd399097d94e603afe02b852112510b66ce05e0bbd6fa94a38c8"
    sha256 cellar: :any,                 x86_64_linux:  "e35c796bc255450ed67cb57a1f28e0918183f3dc437f5812d1e252807a701e1c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: %w[
    cython flit-core packaging setuptools setuptools-git-versioning wheel
  ]

  resource "cython" do
    url "https://files.pythonhosted.org/packages/99/ca/18e324972e5cac914816fdd7bb03e19a455b90039c277a538f7781b50c85/cython-3.3.1.tar.gz"
    sha256 "e0e45989e821bef6aa9ae15c7d583ab5e055f7406c4b3624e49e06d24e90375a"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/d3/8b/0370578a456986d6995344967a479dd5c9d4e064681550c2a9594bb58b4a/flit_core-4.2.0.tar.gz"
    sha256 "84e4e4d8fdd45ba2613800a3ebc6834de26d47ec9746efc3719f94181137b460"
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
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "setuptools-git-versioning" do
    url "https://files.pythonhosted.org/packages/66/b4/a6d4757f1687aac56e74dc4952878c7c9dcd02a5c3256a5020b205e236e4/setuptools_git_versioning-3.2.0.tar.gz"
    sha256 "27aa1ad0409b632ee49947ea592cc27e16fbb2a1605cc22efeb7c353fd790b31"
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

    # Build PyYAML's native extension with a backend for the application's Python.
    build_resources = %w[
      flit-core
      packaging
      setuptools
      wheel
      setuptools-git-versioning
      cython
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vsg --version")

    system libexec/"bin/python", "-c", <<~PYTHON
      import yaml
      import yaml._yaml
      assert yaml.__with_libyaml__
      data = {"ports": ["clock", "reset"], "width": 8}
      assert yaml.load(yaml.dump(data, Dumper=yaml.CSafeDumper), Loader=yaml.CSafeLoader) == data
    PYTHON

    (testpath/"test.vhdl").write <<~VHDL
      ENTITY   test IS
      END ENTITY test;
    VHDL

    shell_output("#{bin}/vsg -p 1 test.vhdl", 1)
    system bin/"vsg", "-p", "1", "--fix", "test.vhdl"

    expected_content = <<~VHDL
      entity test is
      end entity test;
    VHDL

    assert_equal expected_content, (testpath/"test.vhdl").read
    system bin/"vsg", "-p", "1", "test.vhdl"
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
