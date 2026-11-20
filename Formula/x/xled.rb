class Xled < Formula
  desc "Transform tabular data using regular expressions"
  homepage "https://github.com/excelano/xled"
  url "https://github.com/excelano/xled/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "19298b6005dd1c2d64aeec7ebdf27272f54bb5ca4b41251f96f195665c796790"
  license "MIT"
  head "https://github.com/excelano/xled.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3efc66527b312efd8635bab01b54d2ab3882f07556f67b85024dd4d1a824b7a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b24b9756d2fa161754dced550135e1d6efb5fad01ac5b03eafe3c61a8de9f9"
    sha256 cellar: :any,                 arm64_linux:   "118c34236e0a2f9072959c44b18b7b51f44efa2a57ec95d88e488f6f21a99ecc"
    sha256 cellar: :any,                 x86_64_linux:  "f4a13aca35b740bfaf2bda9c8b1b8275dda23fc780b9453233a246d0f593ce56"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xled --version")
    (testpath/"input.csv").write("name\nold\n")
    assert_equal "name\nnew\n", shell_output("#{bin}/xled '[name] s/old/new/' #{testpath}/input.csv")
  end
end
