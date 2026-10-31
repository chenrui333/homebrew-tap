class OpenhandsAgentCanvas < Formula
  desc "Web control center for OpenHands agents"
  homepage "https://github.com/OpenHands/OpenHands"
  url "https://github.com/OpenHands/OpenHands/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "720926b3cc292340a1c011c0aeae894980e1aa22d65e50f533514cd74adbf81f"
  license "MIT"
  head "https://github.com/OpenHands/OpenHands.git", branch: "main"

  depends_on "node"
  depends_on "python@3.13"
  depends_on "uv"

  # Build tools acquire source dependencies; the test serves a loopback fixture.
  allow_network_access! [:build, :test]

  def install
    ENV["ELECTRON_SKIP_BINARY_DOWNLOAD"] = "1"
    system "npm", "ci", "--ignore-scripts"
    # The built frontend passes this path to the separately managed Python backend.
    inreplace "vite.config.ts", 'isLibraryBuild ? "" : EXTENSIONS_SKILLS_DIR',
              "isLibraryBuild ? \"\" : \"#{opt_libexec}/node_modules/@openhands/extensions/skills\""
    system "npm", "run", "build:app"
    system "npm", "prune", "--omit=dev", "--ignore-scripts"
    libexec.install "bin", "build", "config", "scripts", "node_modules", "package.json"
    if OS.linux?
      # Keep the glibc bindings; npm also installs unusable musl variants.
      native_packages = %w[
        lightningcss-linux-*-musl
        @rolldown/binding-linux-*-musl
        @tailwindcss/oxide-linux-*-musl
      ]
      native_packages.each { |pattern| (libexec/"node_modules").glob(pattern).each { |dir| rm_r(dir) } }
    end
    (bin/"agent-canvas").write <<~SH
      #!/bin/bash
      export PATH="#{formula_opt_bin("uv")}:$PATH"
      export UV_PYTHON="${UV_PYTHON:-#{formula_opt_bin("python@3.13")}/python3.13}"
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/agent-canvas.mjs" "$@"
    SH
    chmod 0755, bin/"agent-canvas"
  end

  def caveats
    <<~EOS
      This installs the source-built Agent Canvas web application and launcher.
      By upstream design, full-stack startup uses uvx to acquire the Python
      agent-server and automation backend on first use. That needs network access.
      Use agent-canvas --frontend-only to serve just the UI without acquiring them.
    EOS
  end

  service do
    run [opt_bin/"agent-canvas", "--host", "127.0.0.1"]
    log_path var/"log/openhands-agent-canvas.log"
    error_log_path var/"log/openhands-agent-canvas.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-canvas --version")
    assert_match "cannot be used together",
                 shell_output("#{bin}/agent-canvas --frontend-only --backend-only 2>&1", 1)
    port = free_port
    pid = spawn bin/"agent-canvas", "--frontend-only", "--host", "127.0.0.1", "--port", port.to_s,
                out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      sleep 1
      html = shell_output("curl --silent --show-error --retry 20 --retry-connrefused --retry-delay 1 " \
                          "http://127.0.0.1:#{port}/")
      assert_match "<html", html
      assert_match "assets/", html
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
