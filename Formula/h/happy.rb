class Happy < Formula
  desc "Mobile and Web client for Claude Code and Codex"
  homepage "https://happy.engineering"
  url "https://registry.npmjs.org/happy/-/happy-1.2.2.tgz"
  sha256 "0e34d6a7a516e541e166d4db1b4c368c9b83139ce8c5573e5ae531375cba5211"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "62a6460b9aabd1e1a88f2e10ebc8657d5c28bd067ad82b563d8683b562c8518b"
    sha256                               arm64_sequoia: "62a6460b9aabd1e1a88f2e10ebc8657d5c28bd067ad82b563d8683b562c8518b"
    sha256                               arm64_sonoma:  "62a6460b9aabd1e1a88f2e10ebc8657d5c28bd067ad82b563d8683b562c8518b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afbfd96dd9887ae704673f5e287307bdbf7dba081c5ed37215dcc7a682bb687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2860a9ff8b6a810b5404215f17b363c67866b40ec81fb3426c20361a14c5da"
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
