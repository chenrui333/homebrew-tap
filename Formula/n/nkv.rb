class Nkv < Formula
  desc "Share your state between services using persisted key value storage"
  homepage "https://github.com/nkval/nkv"
  url "https://github.com/nkval/nkv/archive/refs/tags/0.0.6.tar.gz"
  sha256 "55d558442f7464f3b5e33d5fb6c66e94d80f56e3c76a1939db313531f5ff8d34"
  license "Apache-2.0"
  head "https://github.com/nkval/nkv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd461e67caf2218ca1eca1820b000a7ed21107c7a855b1f103c52bf7303447ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc068e55ed11a0ac2197e8a6d7a9c05e38d16775c8a9df182533703baabd4fc5"
    sha256 cellar: :any,                 arm64_linux:   "622513d4e65924f328e2e96d61a73e99cc66fc498296db6cfb4d234ecebf1153"
    sha256 cellar: :any,                 x86_64_linux:  "3f5ef341d329abfbf0a77b86c399d16a59d69f5522063cf0d4f4d8f5e2d8086f"
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
    # assert_match version.to_s, shell_output("#{bin}/nkv-client --version")
    system bin/"nkv-client", "--version"

    output_log = testpath/"output.log"
    pid = spawn bin/"nkv-server", "--level", "debug", "--addr", testpath/"nkv.sock", "--dir", testpath/"data",
                [:out, :err] => output_log.to_s
    sleep 1
    assert_match "nkv_server\e[0m\e[2m:\e[0m log level is DEBUG logs will be saved to: logs", output_log.read
    assert_path_exists testpath/"data"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
