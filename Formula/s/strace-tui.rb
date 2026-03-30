class StraceTui < Formula
  desc "Terminal user interface for visualizing and exploring strace output"
  homepage "https://github.com/Rodrigodd/strace-tui"
  url "https://github.com/Rodrigodd/strace-tui/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "da3ee283c3e293392ddba9a8608c5fe045537ae700c34b4582fedefa5bd808dd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42d841b78a6e8bd53f1b0279372a40ad26d630361656e9edd11845ef87aced63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24107ad36c6cab82b325d861b79b65f2a2ad582889a2d5bb47adb39cbe994e5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc449eaecd674cc8eb41ad61a57665d3406c1470a5b8898b695e06eaa295903d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79ef2f13f92515c967dc5bcd84e65fd01b1f51d98a5264585a5a7b805b121515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f61d7eab6c5743d5b2cb071359f21970abf9853b657e105abbfba26fdb0f6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
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
