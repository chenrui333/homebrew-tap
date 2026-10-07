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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5d263dbb9120fa3a7b13741f39cdd84e73708f96745097e82f5b10b44785e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d263dbb9120fa3a7b13741f39cdd84e73708f96745097e82f5b10b44785e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51afd975ceca8e6e999d7d971670ba86286200459113f0770baaf5752ff80450"
    sha256 cellar: :any,                 x86_64_linux:  "6dad58157f2a8e91dbd801a10aac06c3ac85d61712166f8dc14954b5b43b6f1d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/imduffy15/token-cli/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"token-cli", shell_parameter_format: :cobra)
  end

  test do
    url = "http://localhost:8080/auth/realms/example-realm/.well-known/openid-configuration"
    output = shell_output("#{bin}/token-cli target create example-realm -t #{url} 2>&1", 1)
    assert_match "dial tcp", output
  end
end
