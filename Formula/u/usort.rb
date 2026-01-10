class Usort < Formula
  include Language::Python::Virtualenv

  desc "Safe, minimal import sorting for Python projects"
  homepage "https://usort.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/71/42/13cd4343e3bc508efad5d2b229af8afa88db3ba66d3ad4f112308cecc1dd/usort-1.1.2.tar.gz"
  sha256 "784f780d85d2a8063e0a24ce4f9bbb7b4cac07028d51394a01789aa7ca130399"
  license "MIT"
  head "https://github.com/facebook/usort.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "93b4c4761d9c9d59ed415edc9935691304967c8ba06829d10830e19b8ed57353"
    sha256 cellar: :any,                 arm64_sequoia: "bff12f6a82082b297b2034b0be374289c76567523882afb47a2f92b3a9fcd1dd"
    sha256 cellar: :any,                 arm64_sonoma:  "ceb36f20f33f7477e5281c0bec5dcc88c4fe36f1b6d24511bea6f8471e2cac78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc9b447a78d701c9df05595cbcfd2ed4af7152d5c56c40674212e1dbb73f896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe6b7d9845371a5420be17ff170894c0584c9bc0b823a4d6abb275700820568"
  end

  depends_on "rust" => :build # for libcst
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/4c/b2/bb8e495d5262bfec41ab5cb18f522f1012933347fb5d9e62452d446baca2/pathspec-1.0.3.tar.gz"
    sha256 "bac5cf97ae2c2876e2d25ebb15078eb04d76e4b98921ee31c6f85ade8b59444d"
  end

  resource "pyyaml-ft" do
    url "https://files.pythonhosted.org/packages/5e/eb/5a0d575de784f9a1f94e2b1288c6886f13f34185e13117ed530f32b6f8a8/pyyaml_ft-8.0.0.tar.gz"
    sha256 "0c947dce03954c7b5d38869ed4878b2e6ff1d44b08a0d84dc83fdad205ae39ab"
  end

  resource "stdlibs" do
    url "https://files.pythonhosted.org/packages/e4/83/ac15c4a3c059725dcb5f5d76270b986808cc12d2d7d417ee540d37609e46/stdlibs-2025.10.28.tar.gz"
    sha256 "18db81f45f7783ddf86b80771e061782c70e2f4a8642843b3c80b42cd774b24f"
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
