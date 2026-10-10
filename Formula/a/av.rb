class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.48.tar.gz"
  sha256 "9500c54b1920a454fd2cd492b74ff4e0cc631d1d92bef8c3c6a08562af7c2987"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "465f79cfe69d0fea2d34ad25e77f8666112d5fdbeb85984ff6822e761e7cdb7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "465f79cfe69d0fea2d34ad25e77f8666112d5fdbeb85984ff6822e761e7cdb7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57bbb14ad17e1c71808c8294c5480a625fef95b0754c57fe92791e40246af16b"
    sha256 cellar: :any,                 x86_64_linux:  "be794cd556eb1854b78a2edcc4b0303104d55dc378add516bd6b086f16ddedb2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
