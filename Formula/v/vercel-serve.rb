class VercelServe < Formula
  desc "Static file serving and directory listing"
  homepage "https://github.com/vercel/serve"
  url "https://registry.npmjs.org/serve/-/serve-14.2.5.tgz"
  sha256 "c0d39ad4cb5b5991b3860eeeba64d8d4f1aeb8f28035b08e12fb86182ca7456f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffafa8f4a6880e603944b4469b6a0ce1e3b1ad346d87f3f377ebda74ad6de440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8eb207ca699a8b7a477d985bb5536d31d6fcc0006f902531b82a755b1902272"
    sha256 cellar: :any_skip_relocation, ventura:       "1f735a792787cf670ad3c77879df7f4f0d0c1818282df9026d925ace1e4c83e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418af365fa6aed1ddcd73c0fe392a7e1ac26f3fbe628e5c1d58de48121fabe9b"
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
