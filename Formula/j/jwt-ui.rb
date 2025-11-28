class JwtUi < Formula
  desc "TUI for decoding and encoding JWT tokens"
  homepage "https://jwtui.cli.rs/"
  url "https://github.com/jwt-rs/jwt-ui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "97c6a8cd998adcf80147aa12084efd5ca5bf2f0ead4645851837967d98114630"
  license "MIT"
  head "https://github.com/jwt-rs/jwt-ui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82724ff9b5253a63ea575b3774b4ed9d01e093f0e96dafeef30e3f0ddfd3fccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a04fd709300ed69b14391cf9752b062b2534a905e05539b033166339cab2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c6315347fba7ec1dbd8f1703efe36b8104361f4aa61596abf130d74386b765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442467f0409bae4636383f2008eafc824d25883fafe8e55f78815527653d9c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "682df4fbdefce58c74e7605e4358f20b97c1d84d2df44a0d67dc80f99198c151"
  end

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
