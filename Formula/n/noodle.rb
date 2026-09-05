class Noodle < Formula
  desc "Terminal REST client"
  homepage "https://github.com/wilfredinni/noodle"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "16187ef194664548eb7e220209a2f1e0633e339760425eced2ee3a4d8db8c383"
  license "Apache-2.0"
  head "https://github.com/wilfredinni/noodle.git", branch: "main"

  depends_on "bun"

  def install
    system "bun", "install", "--frozen-lockfile", "--production"
    libexec.install "src", "assets", "node_modules", "package.json"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    libexec.glob("node_modules/@opentui/core-*").each do |path|
      rm_r path unless path.basename.to_s.end_with?("-#{os}-#{arch}")
    end
    (bin/"noodle").write <<~SH
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" "#{libexec}/src/app/cli.ts" "$@"
    SH
    chmod 0755, bin/"noodle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noodle --version")
    output = shell_output("#{bin}/noodle workspace list")
    assert_match "collection", output.downcase
  end
end
