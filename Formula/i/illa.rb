class Illa < Formula
  desc "Deploy a modern low-code platform in 5 Seconds"
  homepage "https://github.com/illacloud/illa"
  url "https://github.com/illacloud/illa/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "4f39ae2a9a4f3287510f509a2abb1b4c658a0258e0fefd6fc276a74d0c1d3a21"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", "1.2.14", version.to_s

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/illa --version")

    ret_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}/illa list --self 2>&1", ret_status)
    assert_match <<~EOS, output
      +----+------+-------+-------+
      | ID | Name | Image | State |
      +----+------+-------+-------+
    EOS
  end
end
