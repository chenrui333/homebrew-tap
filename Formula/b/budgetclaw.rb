class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.123.tar.gz"
  sha256 "97a32ad244fe4a9e2e3fe596942303acbba771ae3e35c682b27fb08a955d11e6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5223585fc8cea4fbe396434084a7fce613e24b3169521827e363f6337e80be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "250fa0f30e6b525cc571b53df44ce03d66feed617bb1f76fdcabcd1e5d905837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f003dc096ef6fd99c3c53725cbca586b6e789dfff47f671fc011779dce86f5"
    sha256 cellar: :any,                 x86_64_linux:  "79b8d9b234cd8fc640c995072cb8dc57ddc91bf231f46e3ee477dc9c8ccbdaa2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
