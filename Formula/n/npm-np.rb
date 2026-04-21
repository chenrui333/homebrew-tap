class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-11.2.0.tgz"
  sha256 "816d99f8e7fa5c0b7aba35f146f8c3b82a5093cd0fba099693470ade05f9e57d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c21189cfaf3c7b0fb510fb5b231339edeab84eee2d67fc02bcdc21040fc058ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c21189cfaf3c7b0fb510fb5b231339edeab84eee2d67fc02bcdc21040fc058ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c21189cfaf3c7b0fb510fb5b231339edeab84eee2d67fc02bcdc21040fc058ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e314d00d41c75bcb032d0debf881bb0059df4144a02743d4503c0540bd965e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e314d00d41c75bcb032d0debf881bb0059df4144a02743d4503c0540bd965e48"
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
