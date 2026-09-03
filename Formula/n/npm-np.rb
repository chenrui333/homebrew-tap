class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-12.1.0.tgz"
  sha256 "67ea1872dfdd9bf63bd6bfb0fb524fed7684f64b12576ac58f578e2c3e521158"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77764121b23df6ec20aa9f5f4b930aa183b902070defd05f1c63607d8cbce739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77764121b23df6ec20aa9f5f4b930aa183b902070defd05f1c63607d8cbce739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77764121b23df6ec20aa9f5f4b930aa183b902070defd05f1c63607d8cbce739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "127e8493606e8124030a3a95efba087ed2c0fc77bcb4dc6d86439a69346cad8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "127e8493606e8124030a3a95efba087ed2c0fc77bcb4dc6d86439a69346cad8b"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/np/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves.
      ln_sf (formula_opt_bin("xsel")/"xsel").relative_path_from(linux_dir), linux_dir
    end

    bin.install_symlink libexec/"bin/np"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/np --version")

    mkdir "test" do
      (testpath/"test/package.json").write <<~EOS
        {
          "name": "test",
          "version": "1.0.0",
          "main": "index.js",
          "scripts": {
            "test": "echo 'Running tests'"
          }
        }
      EOS

      # Setup test git repo
      system "git", "init", "--initial-branch", "main"
      system "git", "config", "user.name", "Test User"
      system "git", "config", "user.email", "test@example.com"
      system "git", "add", "package.json"
      system "git", "commit", "-m", "Initial commit"

      (testpath/"test/index.js").write("console.log('Hello, world!');")
      system "git", "add", "index.js"
      system "git", "commit", "-m", "Add index.js"

      output = shell_output("#{bin}/np --no-cleanup --no-publish --yolo patch")
      assert_match "Publish a new version of test", output
    end
  end
end
