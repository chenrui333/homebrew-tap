class Vsg < Formula
  include Language::Python::Virtualenv

  desc "VHDL Style Guide"
  homepage "https://github.com/jeremiah-c-leary/vhdl-style-guide"
  url "https://github.com/jeremiah-c-leary/vhdl-style-guide/archive/refs/tags/3.30.0.tar.gz"
  sha256 "cd394fa6feebe7aa704a41aed9c743baf701d60807f73d191717dcfa188d240c"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "335d50822fb948522c1e2154a5c683b3ba1c5fc06c6c7a4681a0c03e673384ef"
    sha256 cellar: :any,                 arm64_sonoma:  "406c7b4150d881576dcc8b1b247c715a0ef48363004d09406312c4c729281b0e"
    sha256 cellar: :any,                 ventura:       "1f08f3235b330c3d582b549c8bfbf6a2aa1e0ee92ed306db4389faeeaf52c875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4212a84ba577f6531253b87b2437fbf52678ef01ff3df2ac520be5e898a0b38"
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
      Total Rules Checked: 879
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
