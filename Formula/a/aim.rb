class Aim < Formula
  desc "Command-line download/upload tool with resume"
  homepage "https://github.com/mihaigalos/aim"
  url "https://github.com/mihaigalos/aim/archive/refs/tags/1.8.7.tar.gz"
  sha256 "d4c6fb9b57f0840e1220532e22bdd520d13aacb874dfaa67c6629a39cf8ce87b"
  license "MIT"
  head "https://github.com/mihaigalos/aim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d88b7c28e9a12ab6a5caf14ae75db4402369ecd52658ee50c03150c78de03b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620a26324ad68e10b1a0f6745f3502d882fc320f3b2ec1386d7cded265fe8bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7610add3e929c90810bf41898222f2f8f51ffc947ffb6b3a8d13a52faa92854"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aim --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"aim", "test", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Serving on:", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
