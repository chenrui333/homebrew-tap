class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-12.0.1.tgz"
  sha256 "a0c5324ffbeba2bfd9e8f224c216a8542e9034ab6151863b711eb5c16c95f38d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4675d7a9d434a5979ee8827db77762d3604a7bfd721da834d849a591275f3e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4675d7a9d434a5979ee8827db77762d3604a7bfd721da834d849a591275f3e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4675d7a9d434a5979ee8827db77762d3604a7bfd721da834d849a591275f3e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e8300d16c384f9d71e75d9e8176d970525b3550147f929dca3423f2e473e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e8300d16c384f9d71e75d9e8176d970525b3550147f929dca3423f2e473e3b"
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
