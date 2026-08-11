class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.20.5.tgz"
  sha256 "d9a984b39f0703de4273ac43951845cc35cf077cc27874d093353bdb9c3e8c50"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1442cf0dcbabe29b12b0d27b74e40e3052fe1fea72ae04589efcc73465a9caa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1442cf0dcbabe29b12b0d27b74e40e3052fe1fea72ae04589efcc73465a9caa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1442cf0dcbabe29b12b0d27b74e40e3052fe1fea72ae04589efcc73465a9caa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3199f9742a7acac290cd53310506224e2e59d15bfde4fd749f27efaa3037f060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3199f9742a7acac290cd53310506224e2e59d15bfde4fd749f27efaa3037f060"
  end

  depends_on "node"

  on_linux do
    depends_on "patchelf" => :build
  end

  def install
    system "npm", "install", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/oh-my-codex/node_modules"
    library_replacements = { "libc.so" => "libc.so.6", "libdl.so" => "libdl.so.2", "libm.so" => "libm.so.6" }
    %w[bare-fs bare-path bare-url].each do |package|
      prebuilds = node_modules/package/"prebuilds"
      native = prebuilds/"#{os}-#{arch}"
      prebuilds.each_child { |dir| rm_r(dir) if dir != native }

      next unless OS.linux?

      binary = native/"#{package}.bare"
      needed = Utils.safe_popen_read("patchelf", "--print-needed", binary).lines.map(&:chomp)
      library_replacements.each do |old, new|
        system "patchelf", "--replace-needed", old, new, binary if needed.include?(old)
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-codex/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    require "open3"

    path = [formula_opt_bin("node"), "/usr/bin", "/bin"].join(File::PATH_SEPARATOR)
    output, status = Open3.capture2e({ "PATH" => path }, bin/"omx", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "failed to launch codex", output
  end
end
