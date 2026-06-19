class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7ba2789a76c781ea565d65b35ca600fd0f1fe3a305c93977dee0a3ac7217c223"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a472215933eaf44bb04d6f2da6d4b97dfd08deb0af7b82e646dd550d8e3828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c87ee1075b31812b515e8e1cfc2de182f6296c9981c670430bbc7a76daa69f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9b8352f7f411cefdad308634d328cebf9e59315237549ae602ee267274a4500"
    sha256 cellar: :any,                 arm64_linux:   "94abc112ef9a884afb529d3d864dff3dffee5a6c744043be0bf9f6b17197a9cc"
    sha256 cellar: :any,                 x86_64_linux:  "0685a34cb1a512017ba5292a53ba021c1722cb15f93be2b366fda0db97c74400"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
