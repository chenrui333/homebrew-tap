class Clawhub < Formula
  desc "Install, update, search, and publish agent skills"
  homepage "https://clawhub.ai"
  url "https://registry.npmjs.org/clawhub/-/clawhub-0.27.0.tgz"
  sha256 "7fd229445ad4f23938384035b25afdb658083839b6ed205eca3074b5d67bbe79"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "769042d6ae7b3949c16fe7e35e7900b14d467bc3bee690847882f5ce220b74f6"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawhub --cli-version")
    assert_path_exists bin/"clawdhub"

    (testpath/".clawhub").mkpath
    (testpath/".clawhub/lock.json").write <<~JSON
      {
        "version": 1,
        "skills": {
          "peekaboo": {
            "version": "1.2.3",
            "installedAt": 1234567890
          }
        }
      }
    JSON

    assert_equal "peekaboo  1.2.3\n", shell_output("#{bin}/clawhub --workdir #{testpath} list < /dev/null")
  end
end
