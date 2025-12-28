# framework: cobra
class TokenCli < Formula
  desc "CLI to interact with OAuth2 infrastructure to generate tokens"
  homepage "https://github.com/imduffy15/token-cli"
  url "https://github.com/imduffy15/token-cli/archive/e26b2968f6cf3a6e455593bdd3e9c39823ef81b3.tar.gz"
  version "1.0.0"
  sha256 "530a8eb098ab3cdf7218b65984167e3a48c7d320cc06b0a57245b1b586e87dc7"
  license "Apache-2.0"

  livecheck do
    skip "No new releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc72aa33500223e4f2afbf8e6ae31f97b80cbe11b9ffba7459d8fad0d5c0cc14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc72aa33500223e4f2afbf8e6ae31f97b80cbe11b9ffba7459d8fad0d5c0cc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc72aa33500223e4f2afbf8e6ae31f97b80cbe11b9ffba7459d8fad0d5c0cc14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1b766b0dc04ca4597a1c599307b646353761c395c94c1d26ea8db5961e2aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b11ad0f0e1a2421f9a596b19b98b3fc328acbe60f351b413a4c8f8741eb1cd8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/imduffy15/token-cli/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"token-cli", shell_parameter_format: :cobra)
  end

  test do
    url = "http://localhost:8080/auth/realms/example-realm/.well-known/openid-configuration"
    output = shell_output("#{bin}/token-cli target create example-realm -t #{url} 2>&1", 1)
    assert_match "connection refused", output
  end
end
