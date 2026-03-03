class VercelServe < Formula
  desc "Static file serving and directory listing"
  homepage "https://github.com/vercel/serve"
  url "https://registry.npmjs.org/serve/-/serve-14.2.6.tgz"
  sha256 "126b5ec79d81a85307ebd1953084526ae181c203276cf64b961a7bee31cb7b81"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ac578e25b1d7528c7e065e6bd896a246df1efd80da57b3f2ff38814aa31a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ac578e25b1d7528c7e065e6bd896a246df1efd80da57b3f2ff38814aa31a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ac578e25b1d7528c7e065e6bd896a246df1efd80da57b3f2ff38814aa31a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c13114543af749ddb37fedab1d5535a7eed43113aec3999103a855d12b7886d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c13114543af749ddb37fedab1d5535a7eed43113aec3999103a855d12b7886d"
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
