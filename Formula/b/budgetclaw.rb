class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.93.tar.gz"
  sha256 "d3e8d327ec6f47663f3fc335d2429c327bb42c2a39eb9c03638be37112961157"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce6d41f28cd175fe77ba96ec9996c5044569fee171a7d8f572155506a12215dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb82cd8055c59af4d525cb3d0608b6be63aad9813766a3c5554440e016c84d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbb9f728298f9f76bd9c031bda6c67a2db3205eee6a28f1406127027b3e37ab"
    sha256 cellar: :any,                 x86_64_linux:  "3d4971617aeceaed98f3f3471dd65cee30db5b92f3a8a8baec2ffdbf36ac9b23"
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
