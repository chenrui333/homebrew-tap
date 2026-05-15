class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "f849fba04915722034bb1a4600bd33d4e3677a1de6b8c99e1ccaa89d2ff380bb"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613ea1c4c34e6ad3533cc089467662491489981df2ca8e3018ad3a02b7cf0f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c569c163f64845b300d06bffca51579eee787065d42274a57a40c09565a96718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a96a810854c31e24bbca07d86e1f2a9f0d5d29c940fd6ab82d1418f338bc68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba3d6cbe33213b5ffe2bd2e42776f03f543e203dbe2854b13cce42cf1c3c4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f8f5825128c83914b474e7eec7bf370ee128e2b95be15f2e8a4a8a2c223c0eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
