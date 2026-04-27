class Codemachine < Formula
  desc "CLI-native orchestration engine for autonomous coding workflows"
  homepage "https://codemachine.co/"
  url "https://registry.npmjs.org/codemachine/-/codemachine-0.8.0.tgz"
  sha256 "13b5b78d7e33e1d6733e8dce05e5b4d41173db44465f6ca559172b517890bcdd"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "adb9560f22748b73256c3fedf967eb1b28442446199ad2d5161f0581f07bd531"
    sha256                               arm64_sequoia: "adb9560f22748b73256c3fedf967eb1b28442446199ad2d5161f0581f07bd531"
    sha256                               arm64_sonoma:  "adb9560f22748b73256c3fedf967eb1b28442446199ad2d5161f0581f07bd531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "299b78fca3b7450098e48db277b0fe5baef9eedff5f4ed860c705e431a73778b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3563da1d70eaa31fe446995d1b85472e1dad3de43d7b8ee6b1910b007bca8bf"
  end

  depends_on "chenrui333/tap/bun"
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
