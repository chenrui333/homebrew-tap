class Reasonix < Formula
  desc "DeepSeek-native coding agent for your terminal"
  homepage "https://github.com/esengine/DeepSeek-Reasonix"
  url "https://github.com/esengine/DeepSeek-Reasonix/archive/refs/tags/v2.61.0.tar.gz"
  sha256 "0f0a283f824ac6e7f54be791c95c9450eec58020019594dd3bd8fa9e1581f851"
  license "MIT"
  head "https://github.com/esengine/DeepSeek-Reasonix.git", branch: "studio"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d221ef2984d7f72b934a16bab1c9099991170027007c453edbec1a6f26e3a9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d221ef2984d7f72b934a16bab1c9099991170027007c453edbec1a6f26e3a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11b0d115eab499f0876edad3c3e4297df85cc73bb2bd1040711606a0ddab8ec"
    sha256 cellar: :any,                 x86_64_linux:  "1ce6ade0146915a2bda40431dbffcbee1fe9bb849795381ae29aab9ed0a9642d"
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

    system "go", "build", *std_go_args(output: libexec/"reasonix", ldflags: "-X main.version=v#{version}"),
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
