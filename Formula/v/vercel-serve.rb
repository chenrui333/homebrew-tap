class VercelServe < Formula
  desc "Static file serving and directory listing"
  homepage "https://github.com/vercel/serve"
  url "https://registry.npmjs.org/serve/-/serve-14.2.7.tgz"
  sha256 "9cc5fa69277761fafd4531a46ee5f9ec37dd0246c3419564a8c08c89fa51f63b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "507d43066e499058c3d65ea3c625ea485635edeab089fc1bb8aff2f1f808f0e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507d43066e499058c3d65ea3c625ea485635edeab089fc1bb8aff2f1f808f0e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7302cbcb49a8727eff28d9c3509ed129e2bff28e51cb0e5ff2a89133ed1151b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7302cbcb49a8727eff28d9c3509ed129e2bff28e51cb0e5ff2a89133ed1151b8"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  # serve is a static file server; the test fetches a page from its loopback listener.
  allow_network_access! :test

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/serve"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serve --version")

    port = free_port

    (testpath/"index.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <h1>Hello, world!</h1>
      </body>
      </html>
    EOS

    pid = spawn bin/"serve", "--listen", port.to_s
    sleep 2

    output = shell_output("curl -s http://localhost:#{port}")
    assert_match "<h1>Hello, world!</h1>", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
