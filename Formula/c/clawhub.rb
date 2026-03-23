class Clawhub < Formula
  desc "Install, update, search, and publish agent skills"
  homepage "https://clawhub.ai"
  url "https://github.com/openclaw/clawhub/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "626e6d704abf0f59e2bdf8d91b49dff1b5ed5e60d62313df6eb9f276ce9e6f2a"
  license "MIT"
  head "https://github.com/openclaw/clawhub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ad3738ffcc3d650a794d0565313e124904c55fbf0c251eaa5aef18fb311e8f83"
  end

  depends_on "node"

  def install
    cli_dir = buildpath/"clawhub-cli"
    cp_r buildpath/"packages/clawdhub", cli_dir

    Dir.glob(cli_dir/"src/**/*test.ts").each do |file|
      rm file
    end
    (cli_dir/"src/semver.d.ts").write("declare module \"semver\";\n")

    cd cli_dir do
      system "npm", "install", *std_npm_args(prefix: false), "-D"
      system "npm", "run", "build"
      system "npm", "pack"
      system "npm", "install", *std_npm_args, "clawhub-#{version}.tgz"
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawhub --cli-version")

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

    assert_equal "peekaboo  1.2.3\n", shell_output("#{bin}/clawhub --workdir #{testpath} list")
  end
end
