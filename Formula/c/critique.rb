class Critique < Formula
  desc "Terminal UI for reviewing git changes"
  homepage "https://critique.work"
  url "https://github.com/remorses/critique/archive/refs/tags/critique@0.3.1.tar.gz"
  sha256 "7d6fabe4d2abb03eb9de36a94607e6f6d7f111355e9da9a8823da66e6ecb422d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a53e884f0491dbe2c2fc7f2d67e626c3980fa82d98c8f0c9c5df4f10dcdc2f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a53e884f0491dbe2c2fc7f2d67e626c3980fa82d98c8f0c9c5df4f10dcdc2f3"
    sha256 cellar: :any,                 arm64_linux:   "7a0e142872903ad7fb304f750e437c3c7b7e2960ec47c26dfe682089f89d9acf"
    sha256 cellar: :any,                 x86_64_linux:  "373f81b21be1ee51f8476c045bfa95eb642eb741f181a58fdf43dbd392ed07fa"
  end

  depends_on "python@3.14" => :build
  depends_on "bun"

  preserve_rpath
  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile"
  end

  def install
    cd "comments-server" do
      system "bun", "run", "build"
    end

    cd "cli" do
      system "bun", "run", "build"
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native_platform = if OS.mac?
      %r{darwin-#{arch}(?:@|/|$)}
    else
      %r{linux-#{arch}(?:-(?:gnu|glibc))?(?:@|/|$)}
    end
    platform_arch = /(?:android|darwin|freebsd|linux(?:musl)?|netbsd|openbsd|sunos|win32)-
      (?:arm|arm64|ia32|ppc64|riscv64|s390x|x64)(?:-[a-z0-9]+)?/x
    node_modules = buildpath / "node_modules"
    node_modules.glob(".bun/**/*").sort_by { |path| -path.to_s.length }.each do |path|
      next unless path.directory?
      next unless path.to_s.match?(platform_arch)

      rm_r(path) unless path.to_s.match?(native_platform)
    end

    node_modules.glob(".bun/**/prebuilds/**/*.node").each do |file|
      description = Utils.safe_popen_read("file", "-b", file)
      native_binary = if Hardware::CPU.intel?
        description.match?(/x86[-_]64|universal binary/i)
      else
        description.match?(/arm64|aarch64|universal binary/i)
      end
      rm file unless native_binary
    end

    if OS.mac?
      node_modules.glob(".bun/**/core.darwin-*.node").each do |file|
        MachO::Tools.change_dylib_id(file, "@rpath/libtakumi_napi_core.dylib")
      end
    end

    libexec.install "cli", "comments-server", "node_modules", "package.json", "bun.lock"
    (bin/"critique").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/cli/dist/cli.js" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/critique --version")

    system "git", "init", "--quiet", testpath
    system "git", "-C", testpath, "config", "user.email", "brew-test@example.com"
    system "git", "-C", testpath, "config", "user.name", "Brew Test"
    (testpath/"sample.txt").write("before\n")
    system "git", "-C", testpath, "add", "sample.txt"
    system "git", "-C", testpath, "commit", "--quiet", "-m", "initial"
    (testpath/"sample.txt").open("w") { |file| file.write("after\n") }
    system "git", "-C", testpath, "add", "sample.txt"
    system "git", "-C", testpath, "commit", "--quiet", "-m", "update"
    output = shell_output("cd #{testpath} && #{bin}/critique difftool HEAD~1 HEAD")
    assert_match "-before", output
    assert_match "+after", output
  end
end
