class Batctl < Formula
  desc "Battery charge threshold manager for Linux laptops"
  homepage "https://github.com/Ooooze/batctl"
  url "https://github.com/Ooooze/batctl/archive/refs/tags/v2026.3.13.tar.gz"
  sha256 "7d7a80a871c162e5dbe873c4a7275d125c3f41fceff87335e3003b45ff32e973"
  license "MIT"
  head "https://github.com/Ooooze/batctl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "90bf721bc42ba3c08862738309c36cce559f0b0594e8ae651004a200203999cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "deeb511ae35f17d7779150180e274435f5ceea913985399cb5f2d5c267acca3f"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"batctl"), "./cmd/batctl"
  end

  test do
    output = shell_output("#{bin}/batctl persist status")
    assert_match "Boot service:", output
    assert_match "Resume service:", output
  end
end
