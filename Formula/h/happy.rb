class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.2.5.tgz"
  sha256 "b90d544f7a0891ec4e5e25d1026e9ed10fcf794255cb64e67933440de666e20b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256               arm64_tahoe:   "5d51ec46f70863ef510c1e2de94911d5e1f587c811f68a194832c7522f796cc4"
    sha256               arm64_sequoia: "5d51ec46f70863ef510c1e2de94911d5e1f587c811f68a194832c7522f796cc4"
    sha256 cellar: :any, arm64_linux:   "68dcf8d42d73cfbd87e6a626e2e147eb613b20e090bd4187f7610c2e742a19b8"
    sha256 cellar: :any, x86_64_linux:  "b28f559bd2168a6eb497298afc641ed1437dd47a55292fc33a4654fa3d6c23dc"
  end

  depends_on "node"
  depends_on "pcre2"

  on_linux do
    depends_on "patchelf" => :build
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    node_modules = libexec/"lib/node_modules/happy/node_modules"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    keep = %W[sharp-#{os}-#{arch} sharp-libvips-#{os}-#{arch}]
    node_modules.glob("@img/sharp-*").each do |dir|
      rm_r(dir) unless keep.include?(dir.basename.to_s)
    end

    pi_tui_native = node_modules/"@earendil-works/pi-tui/native"
    pi_tui_native.each_child { |dir| rm_r(dir) if dir.basename.to_s != os }
    prebuilds = pi_tui_native/os/"prebuilds"
    prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" } if prebuilds.exist?

    if OS.linux?
      node_modules.glob("@libsql/linux-*-musl").each { |dir| rm_r(dir) }
      node_modules.glob("@ff-labs/fff-bin-linux-*-musl").each { |dir| rm_r(dir) }

      libvips = (node_modules/"@img/sharp-libvips-#{os}-#{arch}/lib").glob("libvips-cpp.so.*").first
      needed = Utils.safe_popen_read("patchelf", "--print-needed", libvips).lines.map(&:chomp)
      system "patchelf", "--replace-needed", "libc.so", "libc.so.6", libvips if needed.include?("libc.so")
    end

    if OS.linux?
      sandbox_runtime = libexec/"lib/node_modules/happy/node_modules/@anthropic-ai/sandbox-runtime"
      unused_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r [
        sandbox_runtime/"dist/vendor/seccomp/#{unused_arch}",
        sandbox_runtime/"vendor/seccomp/#{unused_arch}",
      ].select(&:exist?)
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "\"version\": \"#{version}\"", (libexec/"lib/node_modules/happy/package.json").read

    with_env(HAPPY_HOME_DIR: testpath/".happy") do
      output = shell_output("#{bin}/happy doctor 2>&1")
      assert_match "Happy CLI Version: #{version}", output
      assert_match "Doctor diagnosis complete!", output
    end
  end
end
