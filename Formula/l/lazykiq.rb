class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2efe046ac9cd86420bc8afcb8ead19e9f95c1a5d1e1136fcae6c32f3eff6d9dc"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c358892e513c58c85b48ec679d904f4cf1180558d4908f4f8ba3e7af117f651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c358892e513c58c85b48ec679d904f4cf1180558d4908f4f8ba3e7af117f651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb58256f8eee40d1efa49cdf0799adaccc5ff9e9cd6319f533a181515d03d10"
    sha256 cellar: :any,                 x86_64_linux:  "93ec3e6af39d91cd41c894d037bd96a1b361ad1e6f4b2dc974c164591e9f59fe"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuiltBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/lazykiq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazykiq --version")
    output = shell_output("#{bin}/lazykiq --redis not-a-url 2>&1", 1)
    assert_match "parse redis url", output
  end
end
