class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "3c8647541a5116102829033748e4c54336e144b00997340da1af2a5baf24560e"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "007a5c969b91efb1db47b0a543654016d982973f4cbc7394e651200dc5ebabd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "007a5c969b91efb1db47b0a543654016d982973f4cbc7394e651200dc5ebabd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "007a5c969b91efb1db47b0a543654016d982973f4cbc7394e651200dc5ebabd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "907cca30c5e4b96e2fec4190160df5d9a6e71cb588a80beac23f188390788f5f"
    sha256 cellar: :any,                 x86_64_linux:  "2ce0e604c37caed51b69c66ba6eb309708433fd1dc6a8225a7e3385957e0ad5c"
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
