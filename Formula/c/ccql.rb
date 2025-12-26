class Ccql < Formula
  desc "Claude Code Query Language"
  homepage "https://github.com/douglance/ccql"
  url "https://github.com/douglance/ccql/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7232525ed2a208d4f35533a57254bac05b8191e17cb9c567f772de66fd634774"
  license "MIT"
  head "https://github.com/douglance/ccql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85db98d3419cf797d28e33e8aa0048d8d7d9062ebeeb211b38d84c1829216005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc874fbddb3e974d2ec25a1a20b78ed5d05f856a1830df18f1bbbf9ebdc3c98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9e10cb21fe7c4d0b54538684447e8a2bdd9b88f7aca1fe1fa564a3ffabdb2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0948762dbc0d5d3723432105c77a6b3bf8313bc70486bc284adf358b221bff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626ebcc1f1d69972427abbc1caf5558dbef4aaaa06bba343d1d35e862dca38d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccql --version")
    (testpath/".claude").mkpath
    assert_match "Total: 0 todos", shell_output("#{bin}/ccql todos")
  end
end
