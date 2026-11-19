class BbApp < Formula
  desc "CLI, local server and host daemon for the bb coding-agent workspace"
  homepage "https://getbb.app"
  url "https://registry.npmjs.org/bb-app/-/bb-app-0.50.1.tgz"
  sha256 "cb20c15e6d1d5a02633ba45802a5406cb57ef8e0c7ac5cc939e0a0f430e66590"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "29393ba764d3e20d163dba3fb8094f84f432675f6e5838af11bf3c7656583c9f"
    sha256               arm64_sequoia: "5a1c9209565823847fe3e0093c752edcfcfe77c6bdf1e7b2c22ce2c51d6509c4"
    sha256 cellar: :any, arm64_linux:   "cfea17da32ad7076da7de751c23c04a6ca717e5e8a5fb8584fd91a625cb8d07f"
    sha256 cellar: :any, x86_64_linux:  "7b6d50c62913703a5f4f24300a737d7648679e2f8ac2222fa1be9e82b9c47e06"
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
