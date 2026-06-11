class Memtui < Formula
  desc "TUI to visualize and manage Memcached"
  homepage "https://github.com/nnnkkk7/memtui"
  url "https://github.com/nnnkkk7/memtui/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "fdbd8b763b9cb628d1a1274f5fd515f9af58f31b88b9e6bd2a5d8f5f1fb12ec1"
  license "MIT"
  head "https://github.com/nnnkkk7/memtui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "085b7f43352db0b595ddeb1fb18446ee2fa3a0b3025ede868ca562c995241ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085b7f43352db0b595ddeb1fb18446ee2fa3a0b3025ede868ca562c995241ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "085b7f43352db0b595ddeb1fb18446ee2fa3a0b3025ede868ca562c995241ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76955ac24dd54d376e467bddb606adf60114999f49ec1a0f03e39d700f2ea9b6"
    sha256 cellar: :any,                 x86_64_linux:  "947c495732af1cd8ac959f0905337aff3092ff0ce284918b7101afa3545f010f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/memtui"
  end

  test do
    assert_match "memtui version #{version}", shell_output("#{bin}/memtui -version")
    assert_match "Memcached server address", shell_output("#{bin}/memtui -h 2>&1")
  end
end
