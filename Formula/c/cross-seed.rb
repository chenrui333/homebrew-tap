class CrossSeed < Formula
  desc "Fully-automatic cross-seeding with Torznab"
  homepage "https://www.cross-seed.org/"
  url "https://registry.npmjs.org/cross-seed/-/cross-seed-6.13.6.tgz"
  sha256 "51b34f05d4d0d70315654ea0051fca6a72d9a11a93bf449544c1a3bbd87018da"
  license "Apache-2.0"

  depends_on "node@24"

  def install
    ENV.prepend_path "PATH", Formula["node@24"].opt_bin
    ENV.prepend_path "PATH", Formula["node@24"].opt_libexec/"bin"
    node_path = "#{Formula["node@24"].opt_bin}:#{Formula["node@24"].opt_libexec/"bin"}:$PATH"

    system "npm", "install", *std_npm_args(ignore_scripts: false)
    (bin/"cross-seed").write_env_script libexec/"bin/cross-seed", PATH: node_path
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cross-seed --version")

    system bin/"cross-seed", "gen-config"
    assert_path_exists testpath/".cross-seed/cross-seed.db"
    assert_match "List of Torznab URLs", (testpath/".cross-seed/config.js").read
  end
end
