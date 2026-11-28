class Plannotator < Formula
  desc "Browser-based plan annotation and code review for coding agents"
  homepage "https://plannotator.ai"
  url "https://github.com/backnotprop/plannotator/archive/refs/tags/v0.29.6.tar.gz"
  sha256 "052dd1eb6dca17ba646da2383c6607eb0bc16aee655f8694ee620b3a9c796b50"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/backnotprop/plannotator.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "f6d5595dd6a48fc173ac3e178a618016bf5826e61f7d02dd63efc0d81dc3251f"
    sha256 arm64_tahoe:   "41113e83190402995dc4e5caa3dd2723177cdf398f4f76d81f58874c9db74fa2"
    sha256 arm64_sequoia: "94ef057f38978acc5a5a1a32f6c5d2cea6774a1b3e762b337cb4c55e465a1408"
    sha256 arm64_linux:   "3cb4b1b74bef9baa018e943a5c73984d719ee3ac75fe367b951552016e3a4dac"
    sha256 x86_64_linux:  "caab269527d59d2a05c9dd45c283ad4c7310b32f9ab8e7c2418acba70db5792d"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  # Build tools acquire source dependencies; the test serves a loopback fixture.
  allow_network_access! [:build, :test]

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "run", "build:viewer-pin"
    system "bun", "run", "build:review"
    system "bun", "run", "build:hook"
    system "bun", "build", "apps/hook/server/index.ts", "--compile", "--no-compile-autoload-bunfig",
                  "--define", "__CLI_VERSION__=\"#{version}\"", "--outfile", "plannotator"
    bin.install "plannotator"
  end

  def caveats
    <<~EOS
      Browser annotation and review run locally without a model provider.
      Optional Ask AI integrations require their upstream provider CLI and credentials.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plannotator --version")
    ENV["PLANNOTATOR_BROWSER"] = "none"
    ENV["PLANNOTATOR_REMOTE"] = "0"
    ENV["PLANNOTATOR_UPDATE_CHECK"] = "0"
    ENV["PLANNOTATOR_INBOX_CONNECT"] = "0"
    ENV["PLANNOTATOR_DATA_DIR"] = (testpath/"data").to_s
    port = free_port
    ENV["PLANNOTATOR_PORT"] = port.to_s
    (testpath/"plan.md").write "# Homebrew review\n\nPackage the local annotation server.\n"
    pid = spawn bin/"plannotator", "annotate", testpath/"plan.md",
                out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      sleep 1
      plan = shell_output("curl --silent --show-error --retry 20 --retry-connrefused --retry-delay 1 " \
                          "http://127.0.0.1:#{port}/api/plan")
      assert_match "Homebrew review", plan
      assert_match "<html", shell_output("curl --silent --show-error http://127.0.0.1:#{port}/")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
