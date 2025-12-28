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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3e76a647fdf58d87935299f206b7178881e6e6a838f323796dadf8a5e6aaab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ac16d9e20038837914ea1f1d05b72b758b29c6cde3ea2758e6f84cd5c62a86"
    sha256 cellar: :any_skip_relocation, ventura:       "b32137c2a57074b0e731c46ceddfc042969c741e94302e72ea5e9004f08ab208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e553403b2c939c8b37e30ddc7d5d1df25bbb976df810cc10a2c3d6953093da"
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
