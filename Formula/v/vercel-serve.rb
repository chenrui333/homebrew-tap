class VercelServe < Formula
  desc "Static file serving and directory listing"
  homepage "https://github.com/vercel/serve"
  url "https://registry.npmjs.org/serve/-/serve-14.2.6.tgz"
  sha256 "126b5ec79d81a85307ebd1953084526ae181c203276cf64b961a7bee31cb7b81"
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

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/serve/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (formula_opt_bin("xsel")/"xsel").relative_path_from(linux_dir), linux_dir
    end
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
