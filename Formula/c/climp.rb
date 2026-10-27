class Climp < Formula
  desc "CLI media player"
  homepage "https://climp.net"
  url "https://github.com/olivier-w/climp/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ca9e77519fa2f71a09bd0e7d80a3ddfaed3a621a916032bc8a29932c7f257c04"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b55216a186ff245be2c091ce786cb0a341c91495e0afb319f5c79bd896bd61e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90cd8a170ea979ce27567fcac5ec684c7f5e44a2da9a188a8279e5d330f6bdc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c1383fd0fcda844097e19d242f7a690c8153aaedd11515cd47f01cd104ab01"
    sha256 cellar: :any,                 x86_64_linux:  "73397ccb0f327bf462f6e11975e530a7335bd9c1769ab0a75fbc24ebc8969274"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/climp --version")

    (testpath/"sample.txt").write("not audio\n")
    output = shell_output("#{bin}/climp #{testpath}/sample.txt 2>&1", 1)
    assert_match "unsupported format .txt", output
  end
end
