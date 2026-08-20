class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.25.tar.gz"
  sha256 "5dc61788681bfeb9376f661185e5bbbe8eafe8df72ace5ca9e44b4537fc21cc2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f32779ef12f591da743408f9c6d2f1b414c3817cea2a8d432b9f64af400605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "859a7e5a36914ed51636d0d8ce0730d52ce549c76dc35375ff6bde645c9c24a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef65d16440fd22d2351c59ca33d4573c831bdc6ebd624934c7fb3c8fd7335e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae283db3e6429937f86531f735c4fcb1cec6b6a5ede22a4d7267635d1ad40b4d"
    sha256 cellar: :any,                 x86_64_linux:  "0fe9f402f3132d7914d95335ab194b6a84943a788aec6e84b223abc7b2f0df90"
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
