class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/0.4.2.tar.gz"
  sha256 "6a2226884509377b873831efc4e4103c007e3e59283baf9598c3bfbc4f3e96b8"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f2d9819122f708355e8bfb2bcdfb451ec63868be70705bfd632c82b44732cbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2d9819122f708355e8bfb2bcdfb451ec63868be70705bfd632c82b44732cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2d9819122f708355e8bfb2bcdfb451ec63868be70705bfd632c82b44732cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d9c2be4582ce6eea973c0317b0e6da1a572df5559eecfcca0b518d3934e8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1186f8ca5236dfee2170f37ae7d8037103f26077fe8e299889f079edd0bee7cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end
