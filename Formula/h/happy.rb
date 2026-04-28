class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.1.7.tgz"
  sha256 "dc04cf8b23c9d64324e3ff77591466ed7805b126e453acb8079d675ea67083d3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "8abbfff1781d100380a301a7618e5cc3ef75f065788392b760b1c847a76fa30f"
    sha256                               arm64_sequoia: "23be6858a987c30f0e09906134f22f20fcaded3b47e5a768267656291115c3e3"
    sha256                               arm64_sonoma:  "23be6858a987c30f0e09906134f22f20fcaded3b47e5a768267656291115c3e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f02f1f7fe7eaa3c9b37603377e952e33f8934e8c0f089bdaef48c737b3ad5756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe0dde608394e816fd429c5ff82a4abae54c028f0f1f6866cb35e8f2c5fbc3c"
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
