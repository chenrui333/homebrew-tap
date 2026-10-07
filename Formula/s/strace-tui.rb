class StraceTui < Formula
  desc "Terminal user interface for visualizing and exploring strace output"
  homepage "https://github.com/Rodrigodd/strace-tui"
  url "https://github.com/Rodrigodd/strace-tui/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "da3ee283c3e293392ddba9a8608c5fe045537ae700c34b4582fedefa5bd808dd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1113a1bf6e541383e1043f6151ac0e6866e13c965f2d240da5f5d41efb5d566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72ea33dcaf5c401fe867e084af77825dd8213d347551cea5fc988de989fd5cc0"
    sha256 cellar: :any,                 arm64_linux:   "b1fc6e6556007d7ca6dbc381f847835b4cc952b5d299180c4bf2df1e27be926c"
    sha256 cellar: :any,                 x86_64_linux:  "5ecf02bdcc91dcce544bffcfe096c56825616fea8217e43a6958a0b3692ac54d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "json"

    sample = <<~EOS
      12345 10:20:30 write(1, "test\\n", 5) = 5
       > /usr/lib/libc.so.6(__write+0x14) [0x10e53e]
      12345 10:20:31 close(1) = 0
    EOS
    (testpath/"trace.txt").write(sample)

    output = shell_output("#{bin/"strace-tui"} parse #{testpath}/trace.txt --json")
    parsed = JSON.parse(output)

    assert_kind_of Array, parsed["entries"]
    assert_equal "write", parsed["entries"].first["syscall_name"]
    assert_kind_of Hash, parsed["summary"]
  end
end
