class JwtUi < Formula
  desc "TUI for decoding and encoding JWT tokens"
  homepage "https://jwtui.cli.rs/"
  url "https://github.com/jwt-rs/jwt-ui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "97c6a8cd998adcf80147aa12084efd5ca5bf2f0ead4645851837967d98114630"
  license "MIT"
  head "https://github.com/jwt-rs/jwt-ui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b9f5044223640ed8fc6956fcb467d3b618541b64c8f7d62c41b20edb1df455"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d692d4a6e4e866b8ac318eb708979831ce844d297432bdd5c1059c59a20fec"
    sha256 cellar: :any,                 arm64_linux:   "c0e1764b3d4e39095b7c6dd59410e7275487da0243b8ab96d75edc00cf6d35e1"
    sha256 cellar: :any,                 x86_64_linux:  "404b9c25b49dccf9d6b912e23767af2bbe6e4ed575fe2f743af50b905d2382c0"
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
    assert_match "jwt-ui #{version}", shell_output("#{bin}/jwtui --version")

    # Demo HS256 JWT with payload:
    # {
    #   "sub": "1234567890",
    #   "name": "John Doe",
    #   "iat": 1516239022
    # }
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." \
            "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ." \
            "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

    output = shell_output("#{bin}/jwtui --stdout --no-verify --json #{token}")
    assert_equal "John Doe", JSON.parse(output)["payload"]["name"]
  end
end
