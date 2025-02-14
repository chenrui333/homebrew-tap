class Usort < Formula
  include Language::Python::Virtualenv

  desc "Safe, minimal import sorting for Python projects"
  homepage "https://usort.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/9b/f4/3ef48b43f2645f2cb4a37d6007e611bc669af44eecfee953c5dd57433011/usort-1.0.8.post1.tar.gz"
  sha256 "68def75f2b20b97390c552c503e071ee06c65ad502c5f94f3bd03f095cf4dfe6"
  license "MIT"
  head "https://github.com/facebook/usort.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "18c91297a910edcd1dd685b5a5d037d9a48c47ad67cfebcf646bcf6a72f427d1"
    sha256 cellar: :any,                 arm64_sonoma:  "19c5a053f648e7a5be66a5a9618ab331b6c1c0f805660fe6db820e3b8f87103b"
    sha256 cellar: :any,                 ventura:       "faad9a1a0d21c426e4d85821db26cc74b165d4ad5a20178c7e28008232d48943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b7bbbdaf749602857b0d78d85fed29588fe88be63269eb61a5e57ab778a6db"
  end

  depends_on "rust" => :build # for libcst
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/f4/ec/d24c0ad33838dfbfe20a760b301d529c63cef32f8b91dae380c97f8bf127/libcst-1.6.0.tar.gz"
    sha256 "e80ecdbe3fa43b3793cae8fa0b07a985bd9a693edbe6e9d076f5422ecadbf0db"
  end

  resource "moreorless" do
    url "https://files.pythonhosted.org/packages/c5/5d/c8ed33403f62a2f755905c8d2d36b71e3fc32588deeb53ad1206edbb067a/moreorless-0.4.0.tar.gz"
    sha256 "85e19972c1a0b3a49f8543914f57bd83f6e1b10df144d5b97b8c5e9744d9c08c"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "stdlibs" do
    url "https://files.pythonhosted.org/packages/c4/19/1bafdce539149fbcae1d173164c297b7b7c9e59a43221555a0d359c132cc/stdlibs-2024.12.3.tar.gz"
    sha256 "b88cf600ac0b80e3d0de0ad6f2be786786db063bccd14b897547fcd9bd7169be"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "trailrunner" do
    url "https://files.pythonhosted.org/packages/4d/93/630e10bacd897daeb9ff5a408f4e7cb0fc2f243e7e3ef00f9e6cf319b11c/trailrunner-1.4.0.tar.gz"
    sha256 "3fe61e259e6b2e5192f321c265985b7a0dc18497ced62b2da244f08104978398"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usort --version")

    (testpath/"test.py").write <<~PYTHON
      import sys
      import os
    PYTHON

    system bin/"usort", "format", "test.py"

    expected_content = <<~PYTHON
      import os
      import sys
    PYTHON

    assert_equal expected_content, (testpath/"test.py").read
  end
end
