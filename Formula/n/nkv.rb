class Nkv < Formula
  desc "Share your state between services using persisted key value storage"
  homepage "https://github.com/nkval/nkv"
  url "https://github.com/nkval/nkv/archive/refs/tags/0.0.6.tar.gz"
  sha256 "55d558442f7464f3b5e33d5fb6c66e94d80f56e3c76a1939db313531f5ff8d34"
  license "Apache-2.0"
  head "https://github.com/nkval/nkv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58f0495dd201b3e2e2e4ad264202a5d7a06c17ad928dd2d58165dee8b4544d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbca07e0293f8fc88bfd2f0f370e97355d6bb58522a5e1586d10207568c23fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86b611d96d8b687d4b4a285ee364d9d6c7f4a8ae7734667f554a4e84a1a6644f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0175125e5b35d6aa6f51a8053825dce3a76b8b88241039823368323810f7394e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85170088bb82162af91c606d3a40c852235f2b7ecbba3984247a074bd34324d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/nkv-client --version")
    system bin/"nkv-client", "--version"

    output_log = testpath/"output.log"
    pid = spawn bin/"nkv-server", "--level", "debug", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "nkv_server\e[0m\e[2m:\e[0m log level is DEBUG logs will be saved to: logs", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
