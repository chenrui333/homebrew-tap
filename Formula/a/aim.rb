class Aim < Formula
  desc "Command-line download/upload tool with resume"
  homepage "https://github.com/mihaigalos/aim"
  url "https://github.com/mihaigalos/aim/archive/refs/tags/1.8.8.tar.gz"
  sha256 "5500e38e48e381557847d09e42dbb093e1e402eb2c2965929cbcdae69ce9ec9e"
  license "MIT"
  head "https://github.com/mihaigalos/aim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2e03c2deecba6da181a909412e6e109ba2dd60aac423e1b43139243fc5f57ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cfb82352c2868ef3c54afc65e48d8e8155236fa79b156b4d2c71d4b4f11c27a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdbd9b75511fc493db92516e5cfcb3ed7c526120862611db65e01b69b9e5ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2b911ea93c16d80124716b8e8a3883df11ec27883f9387f761b5f44680629cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329e6d8f95d07b94dee6cd0339dfbbb973e61142e9790c7acfe65e7a56f5c47d"
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
