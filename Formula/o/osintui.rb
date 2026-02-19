class Osintui < Formula
  desc "Open Source Intelligence Terminal User Interface"
  homepage "https://github.com/wssheldon/osintui"
  url "https://static.crates.io/crates/osintui/osintui-0.1.1.crate"
  sha256 "732444225882845e6148e0fcc1ab4351454180014eb605f2133c490a1314b703"
  license "MIT"
  head "https://github.com/wssheldon/osintui.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"osintui", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Config will be saved to", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
