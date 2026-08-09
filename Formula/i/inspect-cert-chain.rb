class InspectCertChain < Formula
  desc "Inspect and debug TLS certificate chains (without OpenSSL)"
  homepage "https://github.com/robjtede/inspect-cert-chain"
  url "https://github.com/robjtede/inspect-cert-chain/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "7286cb251fcc6cf10b513d640ed2cfcf4e9f183905c4032bef43ae2a608c85ee"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/robjtede/inspect-cert-chain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "478f11d6f2bf0e2e0304a1065187f44b720cc64bfaacacc2769f00fedf217b1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e42cf6a7a947f755ef1be3aaad403c50a91ef53df402b40be90b348d9f06717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ba4fa39824bdfb0c93e5d7ab51337d2125e16d85ca3338ecc280ba5a368a1c"
    sha256 cellar: :any,                 arm64_linux:   "48aecfcfdc79c66decc73b31860c94c9a37f29508b1d8295180d171df613682b"
    sha256 cellar: :any,                 x86_64_linux:  "40baed4cd7107d15b8c7724099387859099e083eed00ff66e7ce31b5aa4b4a99"
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
