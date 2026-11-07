class BbApp < Formula
  desc "CLI, local server and host daemon for the bb coding-agent workspace"
  homepage "https://getbb.app"
  url "https://registry.npmjs.org/bb-app/-/bb-app-0.49.0.tgz"
  sha256 "7298f3cedf0efdea13d0d1b8bff38f2ff88f6dcf59c759b5618ac9346a2f537e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "d1fe957294ddaf53eee60cc38aeccd7d3b8aef75b5eeff12c4de16faa8cf6555"
    sha256               arm64_sequoia: "245d6decd345229679bebb1830a17aaa4a093a3e0535659892b908c9c3653845"
    sha256 cellar: :any, arm64_linux:   "8c7ad75867e077dbfdae09df569cb969c40b191e73f005d64630f908e1cb9c4e"
    sha256 cellar: :any, x86_64_linux:  "821e0750bc1588010c2218d82bb46e49c6afd1b0ecc36c3580a2a51278466d97"
  end

  head do
    url "https://github.com/get-bb/bb.git", branch: "main"
    depends_on "pnpm" => :build
  end

  depends_on "python@3.14" => :build
  depends_on "libuv"
  depends_on "node@22"

  resource "bare-compat-napi" do
    url "https://registry.npmjs.org/bare-compat-napi/-/bare-compat-napi-1.3.8.tgz"
    sha256 "f295dfcf147e1341bd098bb9d77f7f5f1d6bd871129415b666022b9e115d381f"
  end

  # Build tools acquire source dependencies; the test serves a loopback fixture.
  allow_network_access! [:build, :test]

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node@22")
    ENV["npm_config_build_from_source"] = "true"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node@22")
    ENV["PYTHON"] = formula_opt_bin("python@3.14")/"python3.14"
    if build.head?
      ENV["ELECTRON_SKIP_BINARY_DOWNLOAD"] = "1"
      ENV["PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD"] = "1"
      system formula_opt_bin("pnpm")/"pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
      system formula_opt_bin("pnpm")/"pnpm", "run", "bb-app:prepare"
    end
    cd(build.head? ? buildpath/"packages/bb-app" : buildpath) do
      package = JSON.parse(Pathname("package.json").read)
      package.delete("devDependencies")
      Pathname("package.json").atomic_write(JSON.generate(package))
      system "npm", "install", *std_npm_args
    end
    app = libexec/"lib/node_modules/bb-app"
    cd app do
      %w[@parcel/watcher better-sqlite3 node-pty].each do |name|
        cd app/"node_modules/#{name}" do
          args = ["rebuild"]
          # better-sqlite3's documented build script overrides its prebuild-only default.
          args << "--force_build=1" if name == "better-sqlite3"
          system formula_opt_bin("node@22")/"node",
                 formula_opt_lib("node@22")/"node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", *args
        end
      end
      fs = app/"node_modules/fs-native-extensions"
      resource("bare-compat-napi").stage do
        compat = Pathname.pwd
        cd fs do
          rm_r "prebuilds"
          os = OS.mac? ? "darwin" : "linux"
          arch = Hardware::CPU.arm? ? "arm64" : "x64"
          output = fs/"prebuilds/#{os}-#{arch}/fs-native-extensions.node"
          output.dirname.mkpath
          flags = OS.mac? ? %w[-bundle -undefined dynamic_lookup] : %w[-shared -fPIC]
          source = OS.mac? ? "src/apple.c" : "src/linux.c"
          system ENV.cc, *flags, "-DNAPI_VERSION=9", "-I#{compat}/include",
                 "-I#{formula_opt_include("node@22")}/node", "-I#{formula_opt_include("libuv")}",
                 "binding.c", "src/shared.c", "src/posix.c", source,
                 "-L#{formula_opt_lib("libuv")}", "-luv", "-o", output
        end
      end
      (app/"node_modules/@parcel").glob("watcher-*").each { |p| rm_r p }
      %w[better-sqlite3 node-pty].each do |name|
        prebuilds = app/"node_modules/#{name}/prebuilds"
        rm_r prebuilds if prebuilds.exist?
      end
    end
    %w[bb bb-app bb-server bb-host-daemon].each do |name|
      (bin/name).write <<~SH
        #!/bin/bash
        exec "#{formula_opt_bin("node@22")}/node" "#{app}/dist/#{name}.js" "$@"
      SH
      chmod 0755, bin/name
    end
  end

  def caveats
    <<~EOS
      This installs bb's standalone CLI, web server and host daemon, not the desktop app.
      Run bb-app start for the complete local stack. Provider CLIs and credentials
      remain user-managed. Node 22 avoids upstream's Node 24 worker-shutdown issue.
    EOS
  end

  service do
    run [opt_bin/"bb-app", "--no-in-app-updates", "start"]
    log_path var/"log/bb-app.log"
    error_log_path var/"log/bb-app.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bb --version")
    ENV["BB_TELEMETRY"] = "false"
    port = free_port
    pid = spawn bin/"bb-server", "--data-dir", testpath/"data", "--server-bind-host", "127.0.0.1",
                "--server-port", port.to_s, out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      sleep 1
      health = shell_output("curl --silent --show-error --retry 30 --retry-connrefused --retry-delay 1 " \
                            "http://127.0.0.1:#{port}/health")
      assert_match "ok", health
      assert_match "<html", shell_output("curl --silent --show-error http://127.0.0.1:#{port}/")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
