class Clawhub < Formula
  desc "Install, update, search, and publish agent skills"
  homepage "https://clawhub.ai"
  url "https://github.com/openclaw/clawhub/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "b90210b33f0d0dea6a2283b0e19a734a2b99a5ccf4373fc8b14b0484fce7be83"
  license "MIT"
  head "https://github.com/openclaw/clawhub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5ab7bc89937340697e288f9ee5a744b62beb231ee7bbcdd8b174938df949cc9c"
  end

  depends_on "node"

  def install
    cli_dir = buildpath/"clawhub-cli"
    cp_r buildpath/"packages/clawhub", cli_dir

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
