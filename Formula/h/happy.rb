class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.2.0.tgz"
  sha256 "183c6060a531d234da5f32c1ff000b5016c7b3c08a4f7056490cd1325a2e67f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "62a6460b9aabd1e1a88f2e10ebc8657d5c28bd067ad82b563d8683b562c8518b"
    sha256                               arm64_sequoia: "62a6460b9aabd1e1a88f2e10ebc8657d5c28bd067ad82b563d8683b562c8518b"
    sha256                               arm64_sonoma:  "62a6460b9aabd1e1a88f2e10ebc8657d5c28bd067ad82b563d8683b562c8518b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afbfd96dd9887ae704673f5e287307bdbf7dba081c5ed37215dcc7a682bb687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2860a9ff8b6a810b5404215f17b363c67866b40ec81fb3426c20361a14c5da"
  end

  depends_on "node"
  depends_on "pcre2"

  def install
    system "npm", "install", *std_npm_args

    if OS.linux?
      sandbox_runtime = libexec/"lib/node_modules/happy/node_modules/@anthropic-ai/sandbox-runtime"
      unused_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r [
        sandbox_runtime/"dist/vendor/seccomp/#{unused_arch}",
        sandbox_runtime/"vendor/seccomp/#{unused_arch}",
      ].select(&:exist?)
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "\"version\": \"#{version}\"", (libexec/"lib/node_modules/happy/package.json").read

    with_env(HAPPY_HOME_DIR: testpath/".happy") do
      output = shell_output("#{bin}/happy doctor 2>&1")
      assert_match "Happy CLI Version: #{version}", output
      assert_match "Doctor diagnosis complete!", output
    end
  end
end
