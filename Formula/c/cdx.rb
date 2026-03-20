class Cdx < Formula
  desc "Use Codex more easily, even away from your desk"
  homepage "https://github.com/ezpzai/cdx"
  url "https://registry.npmjs.org/@ezpzai/cdx/-/cdx-1.0.7.tgz"
  sha256 "cbeb0c7770b65488120edcbbd88a828b6165ba8b37e049a9a009fe2736626124"
  license "Apache-2.0"
  head "https://github.com/ezpzai/cdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "83678ed7b88fe14c96c22ee6d68c1ee5257ff164e427b5135119ca4c55b73a39"
    sha256                               arm64_sequoia: "9da7502f7c9961dba8bfaa0aae0513f0ae6e2a85a0c7444f0e26ddac8d6881e8"
    sha256                               arm64_sonoma:  "9303ea6bf9a6eb9167a8017a5d810f67507ff40e7cc26172fd6b5d03c75f0fa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81c60c17ff77c4f00bc6101e78c83a5e1728d45049a5fb28a534f2cbb98983f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6edea6538f61be43e910e305c9e5c909095c7d3b69ab0419b1c59a419d8067"
  end

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
