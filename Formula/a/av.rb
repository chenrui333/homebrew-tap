class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "aeab6c2e5870cba80380b92b88edd4f193e4b18954e324c50000d044fd699a5e"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "898d9907504e491b4ed125fc10d186b0e284c635c786143428ec5941417939b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898d9907504e491b4ed125fc10d186b0e284c635c786143428ec5941417939b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898d9907504e491b4ed125fc10d186b0e284c635c786143428ec5941417939b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3b951acf1b60a402bafc4426ac8e58faf2cdb66279a2b70b2fd3d1e13e62d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b7aec6152ee105308778230a7fbef092a320691158821af6ce4833f9e6c1d5"
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
