class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "3ebc6f7c97d01f81f4c1b978bfe3cddaf60015b7a0a8e00719a1dd010f5c9bec"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8ecfd4e4cbbe53c2df261c1a19ce4f5eb13a943ebee314415634c42736bbf61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5118e1b7416cd501cc573d844ecfee7187a643e2ffc2ec3d30cbe441fa45b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e76d278f5212592dd3fc52565c5c102f211c6a0f3dad3e38627b4d35fe5efdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c766231f30ee565c1dda70610dd370f343feabbdcc811f6e77c20534df12cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574f98da210f5b419fad14a0838a0d3b9680e6c5cda92adb8868fddcfaf67168"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
