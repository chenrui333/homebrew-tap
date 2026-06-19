class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.11.tgz"
  sha256 "668b0652cd496d52073fbbb1af00d17ac1b2ac48a0de9a05cb4b02dfc84a624f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2f30e8135f82ef3ce7363c800473eaa551be855232fdbe9637dea6e425c1d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f30e8135f82ef3ce7363c800473eaa551be855232fdbe9637dea6e425c1d81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f30e8135f82ef3ce7363c800473eaa551be855232fdbe9637dea6e425c1d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49421c23bab6a878732f66ae90485d7de36ca273dc406e3b2cd84a010e53aa4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50f4a44357d8ffd136cdbd70e206a1bd5d8154f26eb21e535376d0398aa1bfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")
    assert_match "newsjack", shell_output("#{bin}/newsjack --help")
  end
end
