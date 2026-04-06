class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "3dd1209f5bdc0316b50bcf6248d87c2e0adc5fddd94206f8fe38962dba31aac1"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68449c461c286345997f1bd1a008f98d3259f08fdcdb9a02f5efd1adb54b5e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68449c461c286345997f1bd1a008f98d3259f08fdcdb9a02f5efd1adb54b5e6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68449c461c286345997f1bd1a008f98d3259f08fdcdb9a02f5efd1adb54b5e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "228634668a010f09268ddf440d6d7925f447296c1d3b5c3700aeda1f84708eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1c3321866ef9ba3bb2eb565c2dc89f5ef9bcf67680524603d4fdb6fe1624df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aviator-co/av/internal/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/av"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av version")

    ENV["GITHUB_TOKEN"] = "testtoken"

    system "git", "init"

    output = shell_output("#{bin}/av init 2>&1", 1)
    assert_match "Failed to determine repository default branch", output
    assert_match "failed to open git repo", output
  end
end
