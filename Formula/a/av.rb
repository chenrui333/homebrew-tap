class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "2d3d5a561a3fee5d7fb55d3b021dc5a8be12cb4fc901fede655154a2166b0ba9"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25801a3ed7b61214e20e9be5e5b219a1cff037d5990a926a9302aa0d2ffa210d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25801a3ed7b61214e20e9be5e5b219a1cff037d5990a926a9302aa0d2ffa210d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25801a3ed7b61214e20e9be5e5b219a1cff037d5990a926a9302aa0d2ffa210d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b89bc42ad7bb4e64bf978bb842da634447e81e2b6b75298609a889abffa50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e804ad170e05a6ea5491033c044b6c520eb30092e0cd089e6e30b666f309cdf7"
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
