class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.2.tgz"
  sha256 "cda70689af6a465091ec36b2e2de9031b991b2f5521d86f7347c09e3a845ce5d"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "c55b780b873a2e4c7b575f27f018da2248910a077bd1e73a07679231ec40435c"
    sha256 cellar: :any, arm64_sequoia: "c55b780b873a2e4c7b575f27f018da2248910a077bd1e73a07679231ec40435c"
    sha256 cellar: :any, arm64_sonoma:  "c55b780b873a2e4c7b575f27f018da2248910a077bd1e73a07679231ec40435c"
    sha256 cellar: :any, arm64_linux:   "8340921c8a035b0db698191c5178c96656bcc2da51141011e49624f7d454a901"
    sha256 cellar: :any, x86_64_linux:  "f2cf1f83e01302e45028195b2f3e1587763da01e43605addb305d8065c4ce0a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

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
