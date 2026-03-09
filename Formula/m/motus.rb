class Motus < Formula
  desc "Dead simple password generator"
  homepage "https://github.com/oleiade/motus"
  url "https://github.com/oleiade/motus/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "eaa547e0821906cba7553ff7a51309cc39d450b215748a907bd7db1614ce0c85"
  license "AGPL-3.0-only"
  head "https://github.com/oleiade/motus.git", branch: "main"

  depends_on "rust" => :build

  def install
    # The clipboard feature pulls in GUI-specific X11 clipboard support on Linux.
    system "cargo", "install", *std_cargo_args(path: "crates/motus-cli"), "--no-default-features"
  end

  test do
    expected = '{"kind":"random","password":"BC6%!vMSga9A"}'
    output = shell_output("#{bin}/motus --seed 42 --output json random -c 12 -n -s").strip
    assert_equal expected, output
  end
end
