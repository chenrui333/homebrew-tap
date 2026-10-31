class Plannotator < Formula
  desc "Browser-based plan annotation and code review for coding agents"
  homepage "https://plannotator.ai"
  url "https://github.com/backnotprop/plannotator/archive/refs/tags/v0.28.42.tar.gz"
  sha256 "cc9760551a2c1664143e0d42fb68111f7481eba55c3769cd29f411a9363f592d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/backnotprop/plannotator.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "75a6e09f352e25a78f1b99b4eebe4016a8dfbfc7a68601841ac7333a48808ae8"
    sha256 arm64_sequoia: "1653388f47b871a446b698aa97d65f61e4b7bb690695453eaa672ffdd58a604e"
    sha256 arm64_linux:   "57e6b80c23327e867095a690a26bcad9a62095a0b664021fc9a4677805ca52bc"
    sha256 x86_64_linux:  "899f0acb3371a9c5d54786ad71fbfad69f70d25576fa651e81245cdd975e354b"
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
