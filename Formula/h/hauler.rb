class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "2a51430e8a88d055f744c948ca14d640b846a9ed2de9ec2f50a92a102d69cd06"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f823ddc6b0514fa7cd62c2c2be3af3a3abf649fbe92235c205c6dbfdf711d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c887a5053a6ed4540811186299cc5fe7314ceb1c6aa1e0f35dcb95f1cec5db4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaa296433dc1c487bfaa8412edca4ab05004538063a3ff2ed5341164b89289cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "135c9de84d2100c8322bbc1ddcef756c0514516210c7e3ab89c47b2e0dfd2311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5fb614350f2b308c70baf035fbedf46b9d24bbda5013a3ea4d26e6b5eebf0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
