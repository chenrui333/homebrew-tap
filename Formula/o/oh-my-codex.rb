class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.8.tgz"
  sha256 "e3fdff8c11e6bdf8a2e457248cae3e3a9e1e4179c7df38962b5c24cff3f16c78"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "268a3bb485dce20a555ca2dbe45d1e3ababb5f9ccaf0e1d0d6b4f6ad071b9cf6"
    sha256 cellar: :any, arm64_sequoia: "268a3bb485dce20a555ca2dbe45d1e3ababb5f9ccaf0e1d0d6b4f6ad071b9cf6"
    sha256 cellar: :any, arm64_linux:   "4bd52cf09a2b0b3821d0f3fc2679cc12142f2e3539b0aab3c0ff8b494003993c"
    sha256 cellar: :any, x86_64_linux:  "bd4208f94ea422126d19f7f361ed00f2cf10b0d8b4891a372b71c68954992819"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"
    %w[bare-fs bare-path bare-url].each do |mod|
      prebuild_dir = libexec/"lib/node_modules/oh-my-codex/node_modules/#{mod}/prebuilds"
      prebuild_dir.each_child { |dir| rm_r(dir) if dir.basename.to_s != native }
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
