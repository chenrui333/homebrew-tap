class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-12.0.0.tgz"
  sha256 "61b774ba147d11f828603fc1502b8d5a81875c50ba0e9d2fffd556e9b0675adb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "563f5943c8f2b78255424f1b4fdff226f1c5b6a57a325f2fa89e87b4c86a1447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "563f5943c8f2b78255424f1b4fdff226f1c5b6a57a325f2fa89e87b4c86a1447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563f5943c8f2b78255424f1b4fdff226f1c5b6a57a325f2fa89e87b4c86a1447"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cfcdd48b7a086bd94e7dc7ddb26a728de439a21d4e18458b164e6cd93f60601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfcdd48b7a086bd94e7dc7ddb26a728de439a21d4e18458b164e6cd93f60601"
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
