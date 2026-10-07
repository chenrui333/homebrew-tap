class Theattyr < Formula
  desc "Terminal theater for playing VT100 art and animations"
  homepage "https://github.com/orhun/theattyr"
  url "https://github.com/orhun/theattyr/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "c21e6051ddaa2640b864f4ece25578bc6d4c8c8d264fb17c0216a54043caa92a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/orhun/theattyr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48dabb1a061a66246e3397eb78f43b5cf8dc3f8cee9b611c780e475c05d0dac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb9628bd11d3daf336c41d0107de8e3ca53fdb84fa855d26e7fcfd17ef366c7"
    sha256 cellar: :any,                 arm64_linux:   "3b619eb16973f9baffd8a72da25215a4ffc20dfe68aed1993cb1a1b75b5e55a3"
    sha256 cellar: :any,                 x86_64_linux:  "2556e07ab45b3c04ae4436e2ce39f92cdf7a13324b07473366260d50f16b0e99"
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
    assert_match version.to_s, shell_output("#{bin}/theattyr --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"theattyr", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "VT100 Animations", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
