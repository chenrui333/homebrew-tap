class Pyp < Formula
  include Language::Python::Virtualenv

  desc "Easily run Python at the shell! Magical, but never mysterious"
  homepage "https://github.com/hauntsaninja/pyp"
  url "https://files.pythonhosted.org/packages/0c/65/c275ff380e4412438577eab23810dd7a1ba2cf54a6ba558a3d22cf0fb68b/pypyp-1.3.0.tar.gz"
  sha256 "97c78f8fd6d4550bf67bb5001a4c5c1fa58184d9bd8256abac3e240fa38aa05c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9096db6fe924b85b313efe7294261e7178e6785822bf940a13fcd5a10f2f4fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a4c14d6893527f92c9822ec1350a19d84b9523f1a74ad635f444515895bdda"
    sha256 cellar: :any_skip_relocation, ventura:       "ed93f9425d3032ede19a48f13ad59d2177fb9e39d12c954f12a750049b3b85d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "003725a544558684dee1cdd930f08ab833527b5904a83aaa5473e5e59a081dfa"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyp --version")
    assert_match "Hello, world!", shell_output("#{bin}/pyp 'print(\"Hello, world!\")'")
  end
end
