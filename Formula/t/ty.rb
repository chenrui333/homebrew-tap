class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/30/78/daa1e70377b8127e06db63063b7dd9694cb2bb611b4e3c2182b9ec5a02a1/ty-0.0.1a31.tar.gz"
  sha256 "b878b04af63b1e716436897838ca6a107a672539155b6fc2051268cd85da9cd6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f5ef5959b87f589823468e8c41717de066381c57d768b2451d0da8075ac58b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fd3b752f7fc6dc8632b128176be43772f6f47462864e4df8221d9f39966f9b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4b3265d6d031786c36141a8fc4c09b2e9df7110938c6aa93a3dd86b3a8c211c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d6f18e240e58e1ffa4f4c6efc8531fa40521fa2ea462d13c7165f8df10586f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77993f37c1eaa66eb65ce12626e77d522f7e9912dff0353cff7ac8c1d821adcc"
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
