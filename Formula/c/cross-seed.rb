class CrossSeed < Formula
  desc "Fully-automatic cross-seeding with Torznab"
  homepage "https://www.cross-seed.org/"
  url "https://registry.npmjs.org/cross-seed/-/cross-seed-6.13.9.tgz"
  sha256 "c5c92366735f9425bb22563c39ec703a9b79bc7f75225d92ed081e6b90a23a69"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c4a3bd377b24e0d4f878d6e4d9e7a938ec34a2c5ef8192df7d7cd6265ac11ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6f2175695e5e0219c9ae108e6eb192f4fd7358c93dc34e0069fdf93b372693b"
    sha256 cellar: :any,                 arm64_linux:   "269ada74682712dee60135def85add9c93d386baf002fc68ed0748da5a7cdab1"
    sha256 cellar: :any,                 x86_64_linux:  "748f9ac55677cca2cc0762aeb1ee7b11e360db5a3cd8f828d5c8234b1e3509f7"
  end

  depends_on "node@24"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node@24")
    ENV.prepend_path "PATH", formula_opt_libexec("node@24")/"bin"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node@24")
    node_path = "#{formula_opt_bin("node@24")}:#{formula_opt_libexec("node@24")/"bin"}:$PATH"

    system "npm", "install", "--offline", *std_npm_args(ignore_scripts: false)
    (bin/"cross-seed").write_env_script libexec/"bin/cross-seed", PATH: node_path
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cross-seed --version")

    system bin/"cross-seed", "gen-config"
    assert_path_exists testpath/".cross-seed/cross-seed.db"
    assert_match "List of Torznab URLs", (testpath/".cross-seed/config.js").read
  end
end
