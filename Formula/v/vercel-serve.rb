class VercelServe < Formula
  desc "Static file serving and directory listing"
  homepage "https://github.com/vercel/serve"
  url "https://registry.npmjs.org/serve/-/serve-14.2.4.tgz"
  sha256 "317f5fe08ccc44f535ba593b99ac14254cc3cd8de1e4e876b284b78ad40c6c41"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad0095b2d710033a2ffd552025618d469bd059c5316cc1dc93b09a01002a08e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "039a01cd06edf1aa8f1f55312f0a73ebaef5a2e9ae765257aee2f1c52d61675f"
    sha256 cellar: :any_skip_relocation, ventura:       "7c0efbe7a226d1fb0be6ef6008aede15e034acf4f441b271ef04f985a28ca347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759fce3c368339c8573d827b964580ce7ae0e5a6ca17580829ee3769ceca151d"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/serve"

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/serve/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
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
