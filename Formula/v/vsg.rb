class Vsg < Formula
  include Language::Python::Virtualenv

  desc "VHDL Style Guide"
  homepage "https://github.com/jeremiah-c-leary/vhdl-style-guide"
  url "https://github.com/jeremiah-c-leary/vhdl-style-guide/archive/refs/tags/3.35.0.tar.gz"
  sha256 "243814d768d14ffa76503d63f4aa60a1c7afd3a561cbda46c0954602fcdff390"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "204a678ee7da68875b64a0164f4f1b38b654e05016d3b6b1a62eb423fe794db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344f4d6820b8619dd1c0a1569a59179bba0f2ae52a3e160dd1e9582a5202c630"
    sha256 cellar: :any_skip_relocation, ventura:       "8dde360e4c58a50ec87a251f805c6ba56a4ac5cef85a817b4fd8ac9b30e16111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f59572412c947ae6b560b120b2f5f3155db7b2c067a5d858e35f94abcc4ba0d"
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
