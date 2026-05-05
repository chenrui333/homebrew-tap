class CrossSeed < Formula
  desc "Fully-automatic cross-seeding with Torznab"
  homepage "https://www.cross-seed.org/"
  url "https://registry.npmjs.org/cross-seed/-/cross-seed-6.13.7.tgz"
  sha256 "cd8936f70c94ec62640d1eba5c4c32315b866efed5d3d3fc1fa22109fb5f11b9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d671cff45e03089826193932591bab201fd35e35fa77dd58d4d2491e860a47ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e043b1b2437a4ddb817250666beb6d81327addca3174df8db42e4e64c2e4399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aecb6992374a3d8662490430010ae0ea8adc8ca3c61c1f4a16dadadedbfe4b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f272c3da7d237371c0a17de092b4179ff0893ff405a61899132daa656287d713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a3de4ac69a1050f1389fccd69b6891b7232329dd84c7b7b5f88c3ef80066a72"
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
