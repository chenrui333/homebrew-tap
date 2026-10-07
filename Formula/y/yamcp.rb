class Yamcp < Formula
  desc "Manage MCP servers and workspaces from the command-line"
  homepage "https://github.com/hamidra/yamcp"
  url "https://github.com/hamidra/yamcp/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "ed23201e068cd001dc49a837d881a44e61b4f5527dd74b735ba2ebb6c2db662d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e7e8743a8edc7c342e422502d32b0a12c4b1edc78950b9be4e34295185066d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c80f4f0b75c3fb873497da795e3ba744cc6d552fead02a3ec0830dedc1caada9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdacbefbdaa3d1992fc7f701aa499aa555b117db291c0f128dc274eb31255618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2deebf1d87d64b8c8e4a715867d5b99df7af114dddeccb3ff5222ce3f34c75e8"
  end

  depends_on "node@24"

  deny_network_access!

  def fetch
    setup_node_env
    system "npx", "-y", "pnpm@9.15.0", "install", "--frozen-lockfile"
  end

  def install
    node_path = "#{formula_opt_bin("node@24")}:#{formula_opt_libexec("node@24")/"bin"}:$PATH"

    setup_node_env
    # npx and pnpm resolve from the caches filled by `fetch`.
    ENV["npm_config_offline"] = "true"
    system "npx", "-y", "pnpm@9.15.0", "run", "build"
    system "npx", "-y", "pnpm@9.15.0", "prune", "--prod"

    libexec.install "dist", "node_modules", "package.json"
    chmod 0755, libexec/"dist/index.js"
    (bin/"yamcp").write_env_script libexec/"dist/index.js", PATH: node_path
  end

  def setup_node_env
    ENV.prepend_path "PATH", formula_opt_bin("node@24")
    ENV.prepend_path "PATH", formula_opt_libexec("node@24")/"bin"
    # Keep the npx package cache and pnpm store in buildpath so `install` can reuse them.
    ENV["npm_config_cache"] = buildpath/".npm"
    ENV["npm_config_store_dir"] = buildpath/".pnpm-store"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamcp --version")
    assert_match "No MCP servers configured", shell_output("#{bin}/yamcp server list")
  end
end
