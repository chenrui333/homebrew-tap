class Codebuff < Formula
  desc "Generate code from the terminal"
  homepage "https://www.codebuff.com/"
  url "https://registry.npmjs.org/codebuff/-/codebuff-1.0.688.tgz"
  sha256 "39b430fdb9c21de80d4c08d152a935abf5f83de14fb039880b9c2b669b228483"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "769f102511e5405af434b4a08c6cdf0f570cf38de3891a09a032aad58a97d0fb"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    require "json"

    package_json = libexec/"lib/node_modules/codebuff/package.json"
    assert_equal version.to_s,
                 shell_output("#{formula_opt_bin("node")}/node -p \"require('#{package_json}').version\"").strip

    config_dir = testpath/".config/manicode"
    config_dir.mkpath
    cached_binary = config_dir/"codebuff"
    cached_binary.write <<~SH
      #!/bin/sh
      printf 'launcher=%s argument=%s\n' "$CODEBUFF_LAUNCHER_PID" "$1"
    SH
    chmod 0755, cached_binary

    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    (config_dir/"codebuff-metadata.json").write JSON.generate(version: version.to_s, target: "#{platform}-#{arch}")

    assert_match(/^launcher=\d+ argument=--version$/, shell_output("#{bin}/cb --version"))
  end
end
