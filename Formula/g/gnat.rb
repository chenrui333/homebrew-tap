class Gnat < Formula
  desc "Keyboard-driven terminal client for managing and monitoring NATS JetStream"
  homepage "https://github.com/galaxy-io/gnat"
  url "https://github.com/galaxy-io/gnat/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "9dbbc3841ed313f6dc4d2bb6f09f60257610dc1f5e83bc302c8b3640720e47cb"
  license "MIT"
  head "https://github.com/galaxy-io/gnat.git", branch: "main"

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
