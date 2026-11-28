class Plannotator < Formula
  desc "Browser-based plan annotation and code review for coding agents"
  homepage "https://plannotator.ai"
  url "https://github.com/backnotprop/plannotator/archive/refs/tags/v0.29.7.tar.gz"
  sha256 "2e102bdd9ba883328d2bf22e6a51ffbbd6eebea15f50cb19d5c557d1594c6b8b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/backnotprop/plannotator.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6f258807291e26ab69f3d66911e23ca15ec27120c06eb7c61cb259d297875ee3"
    sha256 arm64_tahoe:   "619abb4bf57b18f4ed12d71eb2f729e2fec8286b2538e07de144fba092eb6b8c"
    sha256 arm64_sequoia: "4548b2001c44e83ee6714d5441d54434abced798e84b88a409bb6250b2457ffc"
    sha256 arm64_linux:   "8a78da2cdb755621c179e26e83abc80ad0ee9bc4e7a1a791b577b630e223737b"
    sha256 x86_64_linux:  "44520b5ae644f8244716879aa24c7c8643a11ff0656669e8741955ddce527200"
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
