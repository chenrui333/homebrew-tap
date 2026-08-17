class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.21.tar.gz"
  sha256 "f4e1aa369a808c24aba9e115bba92aa7c32f1b8b1cd3292217a215e0500022a9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89be60427c6a2d4bd79648802376a4a44bcaaff0f9c1f1bfc9989515dd24131b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d586b2d630e9e0c5dfc11dbbbe76a94ce87a201636b61dcaa8e8e64a63f815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ed7179c386929468e814e81ab9140a9c36e4e9910e8b4c32cbcb77e6e5bf16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df2bbd9fc1b79447930fbe28236b36fc1b3a2bcb5c170eebf46e90f21b38a7bf"
    sha256 cellar: :any,                 x86_64_linux:  "400bad4bf40e26281a654db8fa551b556fa9b253146696f5e53227c059393904"
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
