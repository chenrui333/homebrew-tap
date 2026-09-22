class Critique < Formula
  desc "Terminal UI for reviewing git changes"
  homepage "https://critique.work"
  url "https://github.com/remorses/critique/archive/refs/tags/critique@0.1.140.tar.gz"
  sha256 "f574ae6b1b34e8e45a3d4edf292f54cb0e12198e4e1b4e6cb880f4c3f27d0104"
  license "MIT"

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
    (testpath/"sample.txt").write("after\n")
    output = shell_output("cd #{testpath} && #{bin}/critique")
    assert_match "sample.txt", output
    assert_match "after", output
  end
end
