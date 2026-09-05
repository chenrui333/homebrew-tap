class BullmqDash < Formula
  desc "Terminal dashboard for BullMQ"
  homepage "https://github.com/quanghuynt14/bullmq-dash"
  url "https://github.com/quanghuynt14/bullmq-dash/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9bc0279f2d446a460402f7af86b0ace27e79795b382583c0956ef204434b665b"
  license "MIT"
  head "https://github.com/quanghuynt14/bullmq-dash.git", branch: "master"

  depends_on "bun"

  def install
    system "bun", "install", "--frozen-lockfile", "--production"
    system "bun", "build.ts"
    libexec.install "dist", "node_modules", "package.json"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    libexec.glob("node_modules/@opentui/core-*").each do |path|
      rm_r path unless path.basename.to_s.end_with?("-#{os}-#{arch}")
    end
    (bin/"bullmq-dash").write <<~SH
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" "#{libexec}/dist/index.js" "$@"
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
