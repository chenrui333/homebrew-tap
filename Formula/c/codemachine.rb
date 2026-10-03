class Codemachine < Formula
  desc "CLI-native orchestration engine for autonomous coding workflows"
  homepage "https://github.com/moazbuilds/CodeMachine-CLI"
  url "https://registry.npmjs.org/codemachine/-/codemachine-0.8.0.tgz"
  sha256 "13b5b78d7e33e1d6733e8dce05e5b4d41173db44465f6ca559172b517890bcdd"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "078eaba2c544eccbb62834be6aa5ee0624adfdfb072c6a388670b15611f41e08"
    sha256                               arm64_sequoia: "078eaba2c544eccbb62834be6aa5ee0624adfdfb072c6a388670b15611f41e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122a5c8fca0f0e480a7dd409aba07881d35008ba210776b710205b190d794f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bba1869fb27f9f7195eb3a050570b6e4a7f3e1c55697388d588c27bf504f153"
  end

  depends_on "homebrew/core/bun"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # These platform-specific OpenTUI artifacts are not used by the shipped CLI binary
    # and their install IDs are not relocatable in Homebrew builds.
    libexec.glob("lib/node_modules/codemachine/node_modules/**/@opentui/core-*").each do |path|
      rm_r path
    end
    libexec.glob("lib/node_modules/codemachine/node_modules/**/*.dylib").each do |path|
      rm path
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"project").mkpath
    cd testpath/"project" do
      assert_match version.to_s, shell_output("#{bin}/codemachine --version")
      assert_match "too many arguments", shell_output("#{bin}/codemachine invalid-command 2>&1", 1)
    end
  end
end
