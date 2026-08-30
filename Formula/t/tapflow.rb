class Tapflow < Formula
  desc "Self-hosted iOS and Android simulator streaming for the whole team"
  homepage "https://github.com/jo-duchan/tapflow"
  url "https://registry.npmjs.org/tapflow/-/tapflow-0.20.0.tgz"
  sha256 "76bd7d48b038f07828121c31860bbca8eb32de586fbc5babd7cfd5e46f7638a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5e257515034fda467c82eb73a6f1ac4b350812efda918e2caa138fe9217dc758"
  end

  depends_on :macos
  depends_on "node"

  on_macos do
    depends_on macos: :tahoe
  end

  preserve_rpath # Preserve the prebuilt nethook dylib ID without expanding its Mach-O header.

  def install
    system "npm", "install", *std_npm_args

    dylib = libexec/"lib/node_modules/tapflow/node_modules/@tapflowio/ios-agent/bin/libtapflow-nethook.dylib"
    MachO::Tools.change_dylib_id(dylib, "@rpath/#{dylib.basename}")

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tapflow --version")

    output = shell_output("#{bin}/tapflow admin not-a-real-subcommand 2>&1", 1)
    assert_match "Unknown subcommand: admin not-a-real-subcommand", output
  end
end
