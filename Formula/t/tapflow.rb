class Tapflow < Formula
  desc "Self-hosted iOS and Android simulator streaming for the whole team"
  homepage "https://github.com/jo-duchan/tapflow"
  url "https://registry.npmjs.org/tapflow/-/tapflow-0.33.0.tgz"
  sha256 "c655b7d42869111fcc438ba85cb4ddd301bdf7f1146d8718b43f02d4a938b000"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "89740fcca5015e1419eb750d486b42a76b377c9eb85a2afaae4aa9ad26eaadfb"
  end

  depends_on :macos
  depends_on "node"

  on_macos do
    depends_on macos: :tahoe
  end

  preserve_rpath # Preserve the prebuilt nethook dylib ID without expanding its Mach-O header.

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

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
