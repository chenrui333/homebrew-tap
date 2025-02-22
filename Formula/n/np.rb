class Np < Formula
  desc "Better `npm publish`"
  homepage "https://github.com/sindresorhus/np"
  url "https://registry.npmjs.org/np/-/np-10.2.0.tgz"
  sha256 "e89644fe0a2100f468f3159f402256fa4392cd5782f28fa174b42e5fd46d30ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd623cc71229ca214bf10643913d74cd57188760f7ddedddaee41a27e121fad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "294773fe50cdf7580ef1d77ce8473348c7fff6081b59e5ee6b09a7e7a6761f76"
    sha256 cellar: :any_skip_relocation, ventura:       "915f117befcb03aef69035f3caa8b501a5e242b407479f1fed684f42cc2dc2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8bd127759dac7895e9b169483620a69cc55b29d1525a98ea177da256b85862"
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
