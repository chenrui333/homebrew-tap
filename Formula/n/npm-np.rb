class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-12.1.1.tgz"
  sha256 "d813fdf48fe61b9d44f0138db1b66479a14d408a0d03a4be4cb87d990a2eb239"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5abb9e5b99d78783b62d312fc9650814f51789e8e175d07bf62f6435cb60cd2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abb9e5b99d78783b62d312fc9650814f51789e8e175d07bf62f6435cb60cd2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108585bc53419c35ba304f226025d8f44e99bc23e00ed64c2dd4bd2922c5c834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "108585bc53419c35ba304f226025d8f44e99bc23e00ed64c2dd4bd2922c5c834"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

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
