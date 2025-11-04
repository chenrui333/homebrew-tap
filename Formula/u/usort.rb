class Usort < Formula
  include Language::Python::Virtualenv

  desc "Safe, minimal import sorting for Python projects"
  homepage "https://usort.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/df/69/8bcbed123ec60ee3e529ec39ebb0bd405cc17bcf101094513ad05c326f6b/usort-1.1.0.tar.gz"
  sha256 "a24d3a19c80d006b82d47319ec42cca740e4a1efceba35465e1fd49393a28966"
  license "MIT"
  head "https://github.com/facebook/usort.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5bfe127307bf5e4ce0c900eae6dc3c8dbfb5a3bcd3b3a894289ff916e3443b5e"
    sha256 cellar: :any,                 arm64_sequoia: "5365e892162d5156b957291268e3d0f896877b3a6eda800b1bf83cefbd087070"
    sha256 cellar: :any,                 arm64_sonoma:  "dc9e4fc9efbca68b4c901b6897656d63ef9352c61c49915561f78781bbde1c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13936f7d93e0635e60657a670605a290742f8eed8426eaba623ca9332aa8f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2ce5d198069813e071b14bf833eff807f5d163adeac92f9c5f455d72c9a44b"
  end

  depends_on "rust" => :build # for libcst
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "libcst" do
    url "https://files.pythonhosted.org/packages/de/cd/337df968b38d94c5aabd3e1b10630f047a2b345f6e1d4456bd9fe7417537/libcst-1.8.6.tar.gz"
    sha256 "f729c37c9317126da9475bdd06a7208eb52fcbd180a6341648b45a56b4ba708b"
  end

  resource "moreorless" do
    url "https://files.pythonhosted.org/packages/8d/85/2e4999ac4a21ab3c5f31e2a48e0989a80be3afc512a7983e3253615983d4/moreorless-0.5.0.tar.gz"
    sha256 "560a04f85006fccd74feaa4b6213a446392ff7b5ec0194a5464b6c30f182fa33"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml-ft" do
    url "https://files.pythonhosted.org/packages/5e/eb/5a0d575de784f9a1f94e2b1288c6886f13f34185e13117ed530f32b6f8a8/pyyaml_ft-8.0.0.tar.gz"
    sha256 "0c947dce03954c7b5d38869ed4878b2e6ff1d44b08a0d84dc83fdad205ae39ab"
  end

  resource "stdlibs" do
    url "https://files.pythonhosted.org/packages/e4/83/ac15c4a3c059725dcb5f5d76270b986808cc12d2d7d417ee540d37609e46/stdlibs-2025.10.28.tar.gz"
    sha256 "18db81f45f7783ddf86b80771e061782c70e2f4a8642843b3c80b42cd774b24f"
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

    generate_completions_from_executable(bin/"usort", shells: [:fish, :zsh], shell_parameter_format: :click)
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
