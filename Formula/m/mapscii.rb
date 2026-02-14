class Mapscii < Formula
  desc "Whole World In Your Console"
  homepage "https://github.com/ascorbic/mapscii"
  url "https://registry.npmjs.org/mapscii/-/mapscii-0.3.1.tgz"
  sha256 "21f18b687975f1decef998664ef6d292cf2379d9e4308a5b4cbb66af240341b3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "61f92600ac54b2ba21f4a000cfdf5ec209c8f1d19d18ee1c3e90658845a071be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"mapscii", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Failed to start MapSCII", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
