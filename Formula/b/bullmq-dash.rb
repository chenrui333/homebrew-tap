class BullmqDash < Formula
  desc "Terminal dashboard for BullMQ"
  homepage "https://github.com/quanghuynt14/bullmq-dash"
  url "https://github.com/quanghuynt14/bullmq-dash/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9bc0279f2d446a460402f7af86b0ace27e79795b382583c0956ef204434b665b"
  license "MIT"
  head "https://github.com/quanghuynt14/bullmq-dash.git", branch: "master"

  depends_on "zig@0.15" => :build
  depends_on "bun"

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.4.3.tar.gz"
    sha256 "3a72427d6cc6c7dc1086d44037d4f4c499ebc38c2e3e67ecf998695e65c8337a"
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--production"
    system "bun", "build.ts"
    libexec.install "dist", "node_modules", "package.json"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    libexec.glob("node_modules/@opentui/core-*").each do |path|
      rm_r path unless path.basename.to_s.end_with?("-#{os}-#{arch}")
    end
    # Homebrew Linux uses glibc; bundled musl variants cannot be linked.
    rm libexec.glob("node_modules/@msgpackr-extract/**/*.musl.node") if OS.linux?
    # Build the FFI library from source with room for Homebrew bottle relocation.
    native_package = libexec/"node_modules/@opentui/core-#{os}-#{arch}"
    resource("opentui").stage do
      cd "packages/core/src/zig" do
        inreplace "build.zig", "addNativeAudioDependencies(b, lib, target, macos_sdk_path);", <<~ZIG
          if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;
          addNativeAudioDependencies(b, lib, target, macos_sdk_path);
        ZIG
        system "zig", "build", "-Doptimize=ReleaseFast"
        library = "libopentui.#{OS.mac? ? "dylib" : "so"}"
        rm native_package/library
        native_package.install Dir["lib/*/#{library}"]
      end
    end
    (bin/"bullmq-dash").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/dist/index.js" "$@"
    SH
    chmod 0755, bin/"bullmq-dash"
  end

  service do
    run [opt_bin/"bullmq-dash", "--web", "--redis-url", "redis://localhost:6379"]
    keep_alive true
    log_path var/"log/bullmq-dash.log"
    error_log_path var/"log/bullmq-dash.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bullmq-dash --version")
    output = shell_output("#{bin}/bullmq-dash queues list 2>&1", 2)
    assert_match "Redis URL is not configured", output
  end
end
