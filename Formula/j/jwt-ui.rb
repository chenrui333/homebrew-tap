class JwtUi < Formula
  desc "TUI for decoding and encoding JWT tokens"
  homepage "https://jwtui.cli.rs/"
  url "https://github.com/jwt-rs/jwt-ui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "97c6a8cd998adcf80147aa12084efd5ca5bf2f0ead4645851837967d98114630"
  license "MIT"
  head "https://github.com/jwt-rs/jwt-ui.git", branch: "main"

  depends_on "rust" => :build

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
