class Vsg < Formula
  include Language::Python::Virtualenv

  desc "VHDL Style Guide"
  homepage "https://github.com/jeremiah-c-leary/vhdl-style-guide"
  url "https://github.com/jeremiah-c-leary/vhdl-style-guide/archive/refs/tags/3.35.0.tar.gz"
  sha256 "243814d768d14ffa76503d63f4aa60a1c7afd3a561cbda46c0954602fcdff390"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b27f0298b12d00e3ffd2424f1de5b0d203a63b62e213f7235d958f69ada5cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da93cadca0fb91ea70b2f7e5f02b916bbf71c15ebda0fd70cc864d69cfee2971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe22656f9b068241e26660fb690688a529b71431173c25ab73abeda7d3798cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e103031e177f5c00162ff9368ca94e83b2da2d276fe15a132192f6937b14a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ffee7d395585493e7e5516e6518e3471e5787f068cd68b7ab394c64995d39e8"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
