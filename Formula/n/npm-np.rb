class NpmNp < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-10.2.0.tgz"
  sha256 "e89644fe0a2100f468f3159f402256fa4392cd5782f28fa174b42e5fd46d30ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24a914c884dacb60056579dabab20d93b2c71604cc92dbedfc73ad04f4de340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe86e72bb4d31053ab0c9f9cf6174a44250ea9f04c419c375d736a5fb10e5f64"
    sha256 cellar: :any_skip_relocation, ventura:       "6e55b25ee7d1b6519c5b1192bcf8c0168e5880aca9f33d05be5c4f977d2ea459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8453ccd9e9441780b06afa0e9ea44a4295cdcffcaced89a57d5257fe59163a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
