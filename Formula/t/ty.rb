class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/fc/71/a1db0d604be8d0067342e7aad74ab0c7fec6bea20eb33b6a6324baabf45f/ty-0.0.1a24.tar.gz"
  sha256 "3273c514df5b9954c9928ee93b6a0872d12310ea8de42249a6c197720853e096"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ff7568e27293ea1b80f6f2ca3f1b2d23a2f4bfeb26f181e252cbd6eed2e51bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "533dd4e173c63e1cafc43195e84b94ef69284fc3af27f540c321ef7722cd0fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf38bd75459a2a14568f777cbbb16c097aee48457a8b66a1e54a1610a828a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e97126315b2deec0833a0ccef2c9d6924fa7697a75a60f0c600dcae40c24dd92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2bfda4125ae128e1b99e3050777cd61d89b4b2b244e71ad27fcec15e618e68f"
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
