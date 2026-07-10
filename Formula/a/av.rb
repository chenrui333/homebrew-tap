class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "3c8647541a5116102829033748e4c54336e144b00997340da1af2a5baf24560e"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82333cd5777942ce5c8b81d68b9004aaeb0eaa7f5f6557cc7f78e38733dcde66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82333cd5777942ce5c8b81d68b9004aaeb0eaa7f5f6557cc7f78e38733dcde66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82333cd5777942ce5c8b81d68b9004aaeb0eaa7f5f6557cc7f78e38733dcde66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "747c2fe3b36f2ce82657f9f351d9f9824109256a3ba70fa776ec35c5120576c4"
    sha256 cellar: :any,                 x86_64_linux:  "d9cca518d4868721a320ba62dc33aa7343bfebed8d621fc2e906aaa1a8542686"
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
