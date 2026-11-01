class Reasonix < Formula
  desc "DeepSeek-native coding agent for your terminal"
  homepage "https://github.com/esengine/DeepSeek-Reasonix"
  url "https://github.com/esengine/DeepSeek-Reasonix/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "fa903633970566d1e55922f21994d4dab8f3807906bf20b7da5ab1efacc15f4a"
  license "MIT"
  head "https://github.com/esengine/DeepSeek-Reasonix.git", branch: "studio"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d259d11fe333a183e18a12105f569ab8e2ea58ed4ce0bcbcbbff16630d659e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d259d11fe333a183e18a12105f569ab8e2ea58ed4ce0bcbcbbff16630d659e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40e4fdf7b02cabf1716da86bb5cf9e0c4dcd9165183a3f94bb7436be25450d6d"
    sha256 cellar: :any,                 x86_64_linux:  "6cf47c19fb4793e23a069364a6620735672cc8a57739a2292133649ffd1b2bcf"
  end

  depends_on "go" => :build
  depends_on "pnpm" => :build
  depends_on "typescript" => :build
  depends_on "bash"
  depends_on "node"
  depends_on "ripgrep"

  on_linux do
    depends_on "bubblewrap"
  end

  # The test starts a loopback server to verify the source-built frontend.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "desktop/frontend-next" do
      system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    end
  end

  def install
    cd "desktop/frontend-next" do
      system "pnpm", "install", "--offline", "--frozen-lockfile"
      # Use the matching source-built Homebrew compiler rather than npm's platform executable.
      system formula_opt_bin("typescript")/"tsc", "-b"
      system "pnpm", "exec", "vite", "build"
      pkgshare.install "dist"
    end

    system "go", "build", *std_go_args(output: libexec/"reasonix", ldflags: "-s -w -X main.version=v#{version}"),
           "./cmd/reasonix"
    (libexec/"frontend-next").install_symlink pkgshare/"dist"
    paths = %w[bash node ripgrep].map { |name| formula_opt_bin(name) }
    paths << formula_opt_bin("bubblewrap") if OS.linux?
    (bin/"reasonix").write_env_script libexec/"reasonix", PATH: "#{paths.join(":")}:$PATH"
    generate_completions_from_executable(bin/"reasonix", "completion")
  end

  service do
    run [opt_bin/"reasonix", "serve", "--addr", "127.0.0.1:8787"]
    working_dir Dir.home
    log_path var/"log/reasonix.log"
    error_log_path var/"log/reasonix.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reasonix --version")

    port = free_port
    pid = spawn bin/"reasonix", "serve", "--addr", "127.0.0.1:#{port}", "--auth", "none",
                out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      output = ""
      60.times do
        output = shell_output("curl --silent http://127.0.0.1:#{port}/ 2>/dev/null || true")
        break if output.include?("<html")

        sleep 1
      end
      assert_match "<html", output
      assert_match "/assets/", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
