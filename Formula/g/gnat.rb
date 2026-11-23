class Gnat < Formula
  desc "Keyboard-driven terminal client for managing and monitoring NATS JetStream"
  homepage "https://github.com/galaxy-io/gnat"
  url "https://github.com/galaxy-io/gnat/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "9dbbc3841ed313f6dc4d2bb6f09f60257610dc1f5e83bc302c8b3640720e47cb"
  license "MIT"
  head "https://github.com/galaxy-io/gnat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b4a09063b99e14d4a574fed436629da081402807b9b0185d5b3bffbe28cd5746"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3075ff1a74bb926f292f3d53d77adef6f73022991587936048436a5a0a19b52e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3075ff1a74bb926f292f3d53d77adef6f73022991587936048436a5a0a19b52e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fde9061c458464d316b75814f3c967c252a7b43a7b5348e272b2989033322612"
    sha256 cellar: :any,                 x86_64_linux:  "6944cb506724292ce0b5783fef046183776089ec50ea096b2ba7054e6eb9d118"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gnat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnat -version")

    output = shell_output("#{bin}/gnat -profile missing 2>&1", 1)
    assert_match "profile \"missing\" not found", output
  end
end
