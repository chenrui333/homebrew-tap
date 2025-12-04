class Ty < Formula
  include Language::Python::Virtualenv

  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/30/78/daa1e70377b8127e06db63063b7dd9694cb2bb611b4e3c2182b9ec5a02a1/ty-0.0.1a31.tar.gz"
  sha256 "b878b04af63b1e716436897838ca6a107a672539155b6fc2051268cd85da9cd6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7b3bfe01a839ec1fd1e3a1f8a4aefe28f369558ef8a90d024556c8288c8ff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efda186b1b16366f42f8c6512f69dc9cc26cb5e2fd4af77546ab127cf6b9c79e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f8e6e8b4a72c5880fd1960211b8fff74925f8d7045af287a6cd6e902906b3e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b55d07f6ad54001c142b1abe2e36d5d1a091e4e977518887eaab9e6f6724b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b128dd074c77d3033c7308641479e5ede56efa44e96e399e1d1cde1f7fef8c68"
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
