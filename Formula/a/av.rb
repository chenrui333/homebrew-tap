class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "f38c749cbaed132bcf2bf121eee71d0923a21fdae8ab40ba6f8b2b8cfe5c7f47"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1855353bdededb73577ab0ded7c70b3225c54dd94ab8b478fd5747edf204da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1855353bdededb73577ab0ded7c70b3225c54dd94ab8b478fd5747edf204da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1855353bdededb73577ab0ded7c70b3225c54dd94ab8b478fd5747edf204da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42d5b1b8f9e988a5a9ba2bc3c8d246f4a6abcd62987ffa810d19958d96a77648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45de76ad8a7ddbac313e6b48d6032715dda66291db0e167b34dc2d1e5214b336"
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
