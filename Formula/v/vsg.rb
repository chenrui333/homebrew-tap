class Vsg < Formula
  include Language::Python::Virtualenv

  desc "VHDL Style Guide"
  homepage "https://github.com/jeremiah-c-leary/vhdl-style-guide"
  url "https://github.com/jeremiah-c-leary/vhdl-style-guide/archive/refs/tags/3.32.0.tar.gz"
  sha256 "d3c76723f9718baaa557c876c5514ecead75e3c8f0c1d0d46148a2cdd5a7558a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "c092badef46ddfa4ad3dde98d9286b0666576f9eecc1cc8e604bf03f395a4272"
    sha256 cellar: :any,                 arm64_sonoma:  "15afc6f9d7b4d8b5c63367f400d207570621e4c6c0eb81ad2c2e5c1a2db15b55"
    sha256 cellar: :any,                 ventura:       "15cc4be3ce535bbf2e9ed14d0a9d3962281b52f548255ffa689afee81151bb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd67f5299afb728b2e76ee86cc6a0006ba644dd727c2ca13f6ff3cdfd8a2a35f"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  # add `starting_version` to override default `0.0.1`
  # see https://github.com/dolfinus/setuptools-git-versioning/blob/master/setuptools_git_versioning.py#L33
  patch :DATA

  def install
    # fix version
    inreplace "pyproject.toml", "3.30.0", version.to_s

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vsg --version")

    (testpath/"test.vhdl").write <<~VHDL
      entity test is
      end entity test;
    VHDL

    assert_match <<~EOS, shell_output("#{bin}/vsg test.vhdl")
      Phase 7 of 7... Reporting
      Total Rules Checked: 881
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
