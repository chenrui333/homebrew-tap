class CrossSeed < Formula
  desc "Fully-automatic cross-seeding with Torznab"
  homepage "https://www.cross-seed.org/"
  url "https://registry.npmjs.org/cross-seed/-/cross-seed-6.13.6.tgz"
  sha256 "51b34f05d4d0d70315654ea0051fca6a72d9a11a93bf449544c1a3bbd87018da"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b745f782943fb301b184ed366a18a58444c4eb8b739fb84bba467c7fef5405ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4db9210ac93cdd46241202ce2288a11a2211f5bdfe56b533174b3801b76870c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e2d9770b7948c06ec8de0ce222b416b57c83d2cf290442f6d8d1dc8d6aa948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e0cabdc13b14eccd4ca13524e44eb9c6c2275822146ffecbc498049a69b389c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972d610d91e979b169ed207e1d4bce24c2d5accd27a014dd25cf1290a9aabf41"
  end

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
