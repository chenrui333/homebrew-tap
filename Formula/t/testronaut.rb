class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.17.tgz"
  sha256 "2a5711b59eb727adbab62102775b912a65a7fd5638ba4344fdc62b00f699cf42"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6b464c34ce70c3d542189910e0fb94e42e607145a559e2914f8ec502056b4cfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59d4e9e4f086acb72fdf5891a8c1029e2b61ce8b0ee3c6134322504aba6e8ce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d4e9e4f086acb72fdf5891a8c1029e2b61ce8b0ee3c6134322504aba6e8ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f76228679639f8e0fee4e2572565ae7e6e2538a84f6c5cd917ee8863724fd83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76228679639f8e0fee4e2572565ae7e6e2538a84f6c5cd917ee8863724fd83c"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end
