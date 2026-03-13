class Clawhub < Formula
  desc "Install, update, search, and publish agent skills"
  homepage "https://clawhub.ai"
  url "https://github.com/openclaw/clawhub/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "203588e0c789aabbd765762a66879f3a8dbf5c4a2cfee88776d0dab0f429e68f"
  license "MIT"
  head "https://github.com/openclaw/clawhub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "933df7491f7da04e4307e1c03df9a570f0835a4ebc290564a13336ae11b164ff"
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
