class Memtui < Formula
  desc "TUI to visualize and manage Memcached"
  homepage "https://github.com/nnnkkk7/memtui"
  url "https://github.com/nnnkkk7/memtui/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "fdbd8b763b9cb628d1a1274f5fd515f9af58f31b88b9e6bd2a5d8f5f1fb12ec1"
  license "MIT"
  head "https://github.com/nnnkkk7/memtui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d97171bf3c6725495123220460952868b319fe71b7ee4ca3ffec9412af971798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d97171bf3c6725495123220460952868b319fe71b7ee4ca3ffec9412af971798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f642300e00d8390a1b78864170b82e714d91399322d459e6b1cf19946efbeb7"
    sha256 cellar: :any,                 x86_64_linux:  "0bf64afa55d863b35eff0d7ca41361a4bf16998bd32b4cac62bf2bd14b819efc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/memtui"
  end

  test do
    assert_match "memtui version #{version}", shell_output("#{bin}/memtui -version")
    assert_match "Memcached server address", shell_output("#{bin}/memtui -h 2>&1")
  end
end
