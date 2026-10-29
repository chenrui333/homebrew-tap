class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2efe046ac9cd86420bc8afcb8ead19e9f95c1a5d1e1136fcae6c32f3eff6d9dc"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbcfb1cc1ce4aa639b4b27b83c6912b3d0b300d596d7786b2bb96fd92b568d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbcfb1cc1ce4aa639b4b27b83c6912b3d0b300d596d7786b2bb96fd92b568d15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c0ab5d1ea4b2f355048775e07d67939149f9d1f94d40beb56ea2a7afc1a9bec"
    sha256 cellar: :any,                 x86_64_linux:  "d02a8f39a844779a5928cc2d155470576639f9b31de9fa9af084deb67fe25c44"
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
