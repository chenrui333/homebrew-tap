class Rslocal < Formula
  desc "Tunnel to localhost built in Rust"
  homepage "https://github.com/bonaysoft/rslocal"
  url "https://github.com/bonaysoft/rslocal/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c2346760596a062130227e659cfa9455097f3dff3cc8ae67fe2c907b6cb14028"
  license "Apache-2.0"

  depends_on "protobuf" => :build # for prost-build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # .config/rslocal/config.ini
    (testpath/".config/rslocal/config.ini").write <<~EOS
      endpoint = "http://localhost:8422"
      token = "rslocald_abc321"
    EOS
    # system bin/"rslocal", "http", "8000"
    output = shell_output("#{bin}/rslocal http 8000 2>&1", 1)
    assert_match "tcp connect error: Connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rslocal --version")
    assert_match version.to_s, shell_output("#{bin}/rslocald --version")
  end
end
