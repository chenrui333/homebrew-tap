class Tftargets < Formula
  desc "Analyze Terraform configs to find directories affected by Git changes"
  homepage "https://github.com/takaishi/tftargets"
  url "https://github.com/takaishi/tftargets/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "942b364fed18fe32de8fad4d5fc7d399feefab39ced60939b98cca016402fb3b"
  license "MIT"
  head "https://github.com/takaishi/tftargets.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb332bfa87cf8384e39d91633b96945559588a780eae4f6ba91223c377932c2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb332bfa87cf8384e39d91633b96945559588a780eae4f6ba91223c377932c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a152a49ef7ff788df7f7da3f88a5b41c46fba9a3683e43643a99e26a3817c42"
    sha256 cellar: :any,                 x86_64_linux:  "450b8ef3e27c14b999d7505250658cd7f0947da76da6a7ae8d5721fc30e5dc0b"
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
