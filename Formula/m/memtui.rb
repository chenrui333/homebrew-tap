class Memtui < Formula
  desc "TUI to visualize and manage Memcached"
  homepage "https://github.com/nnnkkk7/memtui"
  url "https://github.com/nnnkkk7/memtui/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "fdbd8b763b9cb628d1a1274f5fd515f9af58f31b88b9e6bd2a5d8f5f1fb12ec1"
  license "MIT"
  head "https://github.com/nnnkkk7/memtui.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/memtui"
  end

  test do
    assert_match "memtui version #{version}", shell_output("#{bin}/memtui -version")
    assert_match "Memcached server address", shell_output("#{bin}/memtui -h 2>&1")
  end
end
