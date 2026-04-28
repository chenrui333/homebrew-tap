class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.1.8.tgz"
  sha256 "f77a7fd1a3a63605ea9fb4f00002e96339c5732f2f507a9e3d9cd4e725f8af5a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6f00e268788e5552b710a60dd837cfc499164a332d3635ef59c408185e6a319e"
    sha256                               arm64_sequoia: "4e75280305238ffbb1281fd179e33e3a85e60b7cce90aefdcaf3e24ba35d5c47"
    sha256                               arm64_sonoma:  "4e75280305238ffbb1281fd179e33e3a85e60b7cce90aefdcaf3e24ba35d5c47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0b4e54d053349a6153fc499cdcf821b8fbf2cd8263f076cd688f69fb01eae22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e34f4f6caa5e16c85b0e1e33c86198bc8d0f9d78be34f15085f175495ad8d4"
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
