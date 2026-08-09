class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "7286cb251fcc6cf10b513d640ed2cfcf4e9f183905c4032bef43ae2a608c85ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8439a39e256ed95f6b151e5faa265338e5b5c2a5b66f5b8f7187f58b1896cc8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db0cec3244a6cb4c2f73c7ef98f43cca02338fbbfb36c0f6ea83bd9eeb000e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612c1dadaf817039758bf5a10802982d5ecc63be7209720f2c347f432a71e2b6"
    sha256 cellar: :any,                 arm64_linux:   "f36f836247bc04241b6e4d83a8ff727dbd270a7bf430c0993a395b878bf90102"
    sha256 cellar: :any,                 x86_64_linux:  "d8545d74f2846045808efafe83107cc9f0d7425dd2092d73e8a2f83f8588d6bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    assert_match version.to_s, shell_output("#{bin}/inspect-cert-chain --version")

    output = shell_output("#{bin}/inspect-cert-chain --host example.com")
    output = output.gsub(/\e\[[0-9;]*m/, "") # Remove ANSI color codes
    assert_match(/Subject: CN=(\*\.)?example\.com/, output)
  end
end
