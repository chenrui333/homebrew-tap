class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "302b7d373f3a6ad988804c144678f43c6f2fa094aa6c9ae02ab8ba9e81fb41fb"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d4e01f9c2911242964ad70991e632b531b3851e0f1caf30f2201d03cb911aca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d4e01f9c2911242964ad70991e632b531b3851e0f1caf30f2201d03cb911aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4e01f9c2911242964ad70991e632b531b3851e0f1caf30f2201d03cb911aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9679f2b37ee5be4b1c5ba4e65a440fd74fc77f4369d29a6635bf9538aa41f7d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81281c4f35baee72d8ce5c7c23731120187b73c0ba7d1735b05559a8332756ca"
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
