class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.3.tgz"
  sha256 "5669424187ed9a46108620371060cae7522fb75e339fad6191a8d381da1e4008"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "db6855d8eb002704ac4015e70533de2747302a3964c507ed296adb0fb1c3d542"
    sha256 cellar: :any, arm64_sequoia: "db6855d8eb002704ac4015e70533de2747302a3964c507ed296adb0fb1c3d542"
    sha256 cellar: :any, arm64_sonoma:  "db6855d8eb002704ac4015e70533de2747302a3964c507ed296adb0fb1c3d542"
    sha256 cellar: :any, arm64_linux:   "a3737a73fba996ba546ff7f50c2aae7f7e462b1635784e181d94ba1665fe6e8d"
    sha256 cellar: :any, x86_64_linux:  "a150607d2398e6776dfbae92ad7b6b2f4218bdd7de2e662ee9a055e188a1f32b"
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
