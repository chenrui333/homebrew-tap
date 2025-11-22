class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/8f/65/3592d7c73d80664378fc90d0a00c33449a99cbf13b984433c883815245f3/ty-0.0.1a27.tar.gz"
  sha256 "d34fe04979f2c912700cbf0919e8f9b4eeaa10c4a2aff7450e5e4c90f998bc28"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a246832ee40167acbc76278f0e980088ba9390d7d648fb697bf469105f991a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde0a6de5748400d3875b728727dc031c79fa88c97a54c3e1f45b77eff952d80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c0a5159c886aa79fbdfe4e0a1154b754b7aa3f7535c547630d0a9ed0ada5377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d202d4e22a636cf08970c5ed1bbc95f0187c6e62c6367c34a97dec205e002846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fdd9f565e1c9db4332def34f41087dc280b7403544982ce057e4bbabfee3792"
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
