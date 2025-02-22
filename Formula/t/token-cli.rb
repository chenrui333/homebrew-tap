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

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/imduffy15/token-cli/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"token-cli", "completion")
  end

  test do
    url = "http://localhost:8080/auth/realms/example-realm/.well-known/openid-configuration"
    output = shell_output("#{bin}/token-cli target create example-realm -t #{url} 2>&1", 1)
    assert_match "connection refused", output
  end
end
