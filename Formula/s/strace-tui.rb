class StraceTui < Formula
  desc "Terminal user interface for visualizing and exploring strace output"
  homepage "https://github.com/Rodrigodd/strace-tui"
  url "https://github.com/Rodrigodd/strace-tui/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "da3ee283c3e293392ddba9a8608c5fe045537ae700c34b4582fedefa5bd808dd"
  license any_of: ["Apache-2.0", "MIT"]

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
