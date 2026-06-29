class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "26c3dd19ff4d641825cee3a0bd3b5dac9b0e9c8e90807a0ed0a16e008b3d8f1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cd4341f3393646125237b6f369d10748766de8dee6179b84f8456af87d1419d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "654208f278f958f3b00073044eba3a8deddc8302ada836f129786c1bdd0237b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0eec3ddaa4b747e13f842d957505d0e4839a381638ed07aa4a0dfb29a230584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d30361f14e3e13089ba6b5747e7782bbb9451b0df8101eb1470cc02a9b018a8"
    sha256 cellar: :any,                 x86_64_linux:  "7087e56813f18d81ebd085c80115c1bc830d63e0fe922a1961b6e7f8fb128027"
  end

  depends_on "go" => :build

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
