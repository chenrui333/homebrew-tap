class Ovis < Formula
  desc "Browser and phone client for herdr terminal workspaces"
  homepage "https://github.com/devswha/ovis"
  url "https://github.com/devswha/ovis/archive/refs/tags/v0.4.21.tar.gz"
  sha256 "bc5f2d79acef4c4100658b63df3f452fc29e2cd4a38ddc93cafbcb1e466ec47e"
  license "MIT"
  head "https://github.com/devswha/ovis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d094f234437d6ce620f2309822fd879bdb5e4392c018a95d48cc460d84b4e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a624e27cb0108aaded9439e2a5acef69844ba37e64750aed69d966273f9b60b"
    sha256 cellar: :any,                 arm64_linux:   "a3c7437e3be90c9a8a924f6cbe3c6e0d535b16d0b6eee9a5cf281a181ec6de4f"
    sha256 cellar: :any,                 x86_64_linux:  "1a46386c71f552a8e72ee8023ae33ce370c0a3ac56f1799c3cd8762909b13424"
  end

  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "bun"
  depends_on "herdr"
  depends_on "node"
  depends_on "openssh"

  # Fetch frontend/native dependencies and exercise the loopback web server.
  allow_network_access! [:build, :test]

  def install
    ENV["npm_config_build_from_source"] = "true"
    # The @lydell distribution contains only prebuilds; use the same upstream
    # node-pty API with its published C++ sources for the fallback PTY engine.
    inreplace "package.json", '"@lydell/node-pty": "1.1.0"',
                              '"@lydell/node-pty": "npm:node-pty@1.1.0"'
    system "bun", "install", "--ignore-scripts"
    system "bun", "run", "build"
    # Ship runtime dependencies only, not build-only platform prebuilt bindings.
    rm_r "node_modules"
    system "bun", "install", "--production", "--ignore-scripts"
    cd "node_modules/@lydell/node-pty" do
      system "npm", "rebuild", "--build-from-source"
      rm_r "prebuilds" if File.directory?("prebuilds")
    end
    system "cargo", "install", *std_cargo_args(path: "crates/pty-sidecar")
    libexec.install "server", "shared", "integrations", "scripts", "dist", "node_modules", "package.json"
    (bin/"ovis").write <<~SH
      #!/bin/bash
      export OVIS_PTY_SIDECAR_BIN="#{opt_bin}/ovis-pty-sidecar"
      export PATH="#{formula_opt_bin("node")}:$PATH"
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/server/index.ts" "$@"
    SH
    chmod 0755, bin/"ovis"
  end

  service do
    run opt_bin/"ovis"
    keep_alive true
    working_dir var
    log_path var/"log/ovis.log"
    error_log_path var/"log/ovis.log"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    ENV["PORT"] = free_port.to_s
    ENV["HOST"] = "127.0.0.1"
    ENV["OVIS_STATE_DIR"] = testpath/"state"
    ENV["OVIS_TELEMETRY"] = "0"
    pid = spawn bin/"ovis", [:out, :err] => (testpath/"server.log").to_s
    begin
      sleep 1
      output = shell_output("curl --retry 10 --retry-connrefused --retry-delay 1 -fsS http://127.0.0.1:#{ENV["PORT"]}/")
      assert_match "<html", output
      assert_match "Ovis", output
      Open3.popen3((bin/"ovis-pty-sidecar").to_s, "80", "24",
                   "/bin/sh", "-c", "printf homebrew-native-pty") do |_stdin, stdout, _stderr, wait_thread|
        assert_match "homebrew-native-pty", stdout.read
        assert_predicate wait_thread.value, :success?
      end
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
