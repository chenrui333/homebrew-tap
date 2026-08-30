class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.2.2.tgz"
  sha256 "0e34d6a7a516e541e166d4db1b4c368c9b83139ce8c5573e5ae531375cba5211"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "122890d660095572b17117a0f82cf7c82f60c2374545bb616381fc66cfa3a0ce"
    sha256               arm64_sequoia: "122890d660095572b17117a0f82cf7c82f60c2374545bb616381fc66cfa3a0ce"
    sha256               arm64_sonoma:  "122890d660095572b17117a0f82cf7c82f60c2374545bb616381fc66cfa3a0ce"
    sha256 cellar: :any, arm64_linux:   "8db69ea1816678a48b02110749efcd55f92ee0a23ca5ebabb6a68189dd0c48f0"
    sha256 cellar: :any, x86_64_linux:  "94e6773a614cf8f125bbb50c5aca77379ed36dff68bc25d96772a4a19df94594"
  end

  depends_on "node"
  depends_on "pcre2"

  on_linux do
    depends_on "patchelf" => :build
  end

  def install
    system "npm", "install", *std_npm_args

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
