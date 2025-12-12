class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/f9/f467d2fbf02a37af5d779eb21c59c7d5c9ce8c48f620d590d361f5220208/ty-0.0.1a34.tar.gz"
  sha256 "659e409cc3b5c9fb99a453d256402a4e3bd95b1dbcc477b55c039697c807ab79"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a1d669dc6375a4e9615ea711ee7dc3e2c49960fc27ca8813b3630755d7315d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ccec04b5fca5a58da360a5c6c1ebd74f23df27773351a53e9c26e3d808473e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6024d3dc2b747051b2c14bfa166911462dcfb95e49766f60aacb292950c13133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556634ac4701883b5770d5528aacb5af6131cd4e6f069d1052ca15f7bed90ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b5a8475ea18e31af2d39913496db5383ad82b66cf1d43f9ff7d23c8fbc2822"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
