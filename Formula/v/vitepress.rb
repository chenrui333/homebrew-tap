class Vitepress < Formula
  desc "Is a Vue-powered static site generator"
  homepage "https://vitepress.dev/"
  url "https://registry.npmjs.org/vitepress/-/vitepress-1.6.4.tgz"
  sha256 "37f38a64e1e8ea1e9db68ad201488327c8df1303d3cdb2ceb0e3754259d65114"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8174542905d0db8e12f6327a4c62c9e73ce759e81a5961e7be4a504572ca8175"
    sha256 cellar: :any,                 arm64_sequoia: "8174542905d0db8e12f6327a4c62c9e73ce759e81a5961e7be4a504572ca8175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7781ff04ff551a8ebf5997d8218e165872079bb9b68ee276293a9f474e1633d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3e24af0039222079923ec15eb507f30b96263a647a7e0b48605effb47b85d6"
  end

  depends_on "node"

  # The test checks the vitepress dev server, which binds a loopback port.
  allow_network_access! :test

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"vitepress", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Network\e[22m\e[2m: use \e[22m\e[1m--host\e[22m\e[2m to expose", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
