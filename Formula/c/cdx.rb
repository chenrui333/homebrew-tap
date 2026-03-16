class Cdx < Formula
  desc "Use Codex more easily, even away from your desk"
  homepage "https://github.com/ezpzai/cdx"
  url "https://registry.npmjs.org/@ezpzai/cdx/-/cdx-1.0.5.tgz"
  sha256 "db1568d7cff1d404d190d77572ee4d044106b979e1dda80ec0e72bbafc01943a"
  license "Apache-2.0"
  head "https://github.com/ezpzai/cdx.git", branch: "main"

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  fails_with :clang do
    build 1699
    cause "node-pty fails to build"
  end

  def install
    ENV["npm_config_build_from_source"] = "true"
    system "npm", "install", *std_npm_args

    Dir.chdir(libexec/"lib/node_modules/@ezpzai/cdx") do
      system "npm", "rebuild", "node-pty", "--build-from-source"
    end

    rm_r(libexec/"lib/node_modules/@ezpzai/cdx/node_modules/node-pty/prebuilds", force: true)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    cdx_home = testpath/".cdx"

    with_env(CDX_HOME: cdx_home.to_s) do
      output = shell_output("#{bin}/cdx mode set balanced")
      assert_match "Set global default mode: balanced", output
      assert_match "balanced", shell_output("#{bin}/cdx mode")
    end

    assert_path_exists cdx_home/"config.json"
  end
end
