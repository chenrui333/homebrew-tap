class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-11.2.0.tgz"
  sha256 "816d99f8e7fa5c0b7aba35f146f8c3b82a5093cd0fba099693470ade05f9e57d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0661740ad56d7b5b68f4b0186af7acfff6cf5e6b4a4b4c0131217ae0086132cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0661740ad56d7b5b68f4b0186af7acfff6cf5e6b4a4b4c0131217ae0086132cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0661740ad56d7b5b68f4b0186af7acfff6cf5e6b4a4b4c0131217ae0086132cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54b2a62094dc2d28702a16750615fdb3a0ed60273b44d9a27c50297db8716b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b2a62094dc2d28702a16750615fdb3a0ed60273b44d9a27c50297db8716b0f"
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
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
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
