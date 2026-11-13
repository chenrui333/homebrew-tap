class Tftargets < Formula
  desc "Analyze Terraform configs to find directories affected by Git changes"
  homepage "https://github.com/takaishi/tftargets"
  url "https://github.com/takaishi/tftargets/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "942b364fed18fe32de8fad4d5fc7d399feefab39ced60939b98cca016402fb3b"
  license "MIT"
  head "https://github.com/takaishi/tftargets.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15ad6ffb8d588984977a3b8cdb5b88d80de1b3a6c06a203d54f395c687f66f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ad6ffb8d588984977a3b8cdb5b88d80de1b3a6c06a203d54f395c687f66f35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dfc66991e1fcdc7b632431496960f9152d77fd7c1f78759559f57e348e56282"
    sha256 cellar: :any,                 x86_64_linux:  "1914f86e8b307dad65bbc48f3770a41576998b26f35c2043c14d5fefa96bb433"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/takaishi/tftargets/cmd/tftargets.Version=#{version}
      -X github.com/takaishi/tftargets/cmd/tftargets.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tftargets"
  end

  test do
    system bin/"tftargets", "--version"
  end
end
