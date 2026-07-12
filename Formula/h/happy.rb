class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.2.0.tgz"
  sha256 "183c6060a531d234da5f32c1ff000b5016c7b3c08a4f7056490cd1325a2e67f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "eaa15669ffc0e0a8af4cafe18e5856634950b8cc6bac9542a76000b63fc355d5"
    sha256                               arm64_sequoia: "eaa15669ffc0e0a8af4cafe18e5856634950b8cc6bac9542a76000b63fc355d5"
    sha256                               arm64_sonoma:  "eaa15669ffc0e0a8af4cafe18e5856634950b8cc6bac9542a76000b63fc355d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225875f8377b99e6abf05ead57eee7e9db82b8c2bdf4a66bf18ec27e5e8d5bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86dc62466c339752612f4be7c36faad9d2bbeb743b2873361bf984b55f213f30"
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
