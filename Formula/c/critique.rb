class Critique < Formula
  desc "Terminal UI for reviewing git changes"
  homepage "https://critique.work"
  url "https://github.com/remorses/critique/archive/refs/tags/critique@0.4.0.tar.gz"
  sha256 "ef297160eabb2bf1d5f62a31cba15f710ae090a356351f14eb70b969b74cee2a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81789a82bd48a071d03a8e03447797e2487d54fe69349dfab6d2a5c173129c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81789a82bd48a071d03a8e03447797e2487d54fe69349dfab6d2a5c173129c4c"
    sha256 cellar: :any,                 arm64_linux:   "b925090c06fb516dd7a74f58c18e8471e8ca865e7ad247dba18f819b3625f6f8"
    sha256 cellar: :any,                 x86_64_linux:  "923a611197ed736f3b5b258bcedf2211f326e613e7acfaa5788fa4a3ff527104"
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
