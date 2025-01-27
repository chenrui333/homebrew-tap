class Rslocal < Formula
  desc "Tunnel to localhost built in Rust"
  homepage "https://github.com/bonaysoft/rslocal"
  url "https://github.com/bonaysoft/rslocal/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c2346760596a062130227e659cfa9455097f3dff3cc8ae67fe2c907b6cb14028"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a2bdbfb42c9f274aeaf32373aba910be5d3e1014114cd6189ffad44e1106b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ec784c098d2a4d57d0a307351fabb092431470d95604a341866182ee4bfd5a"
    sha256 cellar: :any_skip_relocation, ventura:       "c2b89997b67a9fe9708b6cbab26e667461dc8358eb8cc1671d3859579550b0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f26705b3f736a5f23f79419da25c1522fe393f6b5c22e860ae2565a74572782"
  end

  depends_on "protobuf" => :build # for prost-build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".config/rslocal/config.ini").write <<~EOS
      endpoint = "http://localhost:8422"
      token = "rslocald_abc321"
    EOS

    output = shell_output("#{bin}/rslocal http 8000 2>&1", 1)
    assert_match "tcp connect error: Connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rslocal --version")
    assert_match version.to_s, shell_output("#{bin}/rslocald --version")
  end
end
