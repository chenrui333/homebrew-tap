class Codemachine < Formula
  desc "CLI-native orchestration engine for autonomous coding workflows"
  homepage "https://codemachine.co/"
  url "https://registry.npmjs.org/codemachine/-/codemachine-0.8.0.tgz"
  sha256 "13b5b78d7e33e1d6733e8dce05e5b4d41173db44465f6ca559172b517890bcdd"
  license "Apache-2.0"

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
