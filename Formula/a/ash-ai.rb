class AshAi < Formula
  desc "Deploy and manage Ash AI agents"
  homepage "https://github.com/ash-ai-org/ash-ai"
  url "https://github.com/ash-ai-org/ash-ai/archive/refs/tags/%40ash-ai%2Fcli%400.0.21.tar.gz"
  sha256 "1e5a5c593668d1b1d53e3e94e2aa0bd5c855bc2bd5fb2eb26da530e88ecf735d"
  license "MIT"
  head "https://github.com/ash-ai-org/ash-ai.git", branch: "main"

  depends_on "node@24"
  depends_on "pcre2"

  def install
    platform_arch = Hardware::CPU.arm? ? "arm64" : "x64"
    platform_os = OS.mac? ? "darwin" : "linux"
    node_path = "#{Formula["node@24"].opt_bin}:#{Formula["node@24"].opt_libexec/"bin"}:$PATH"

    ENV.prepend_path "PATH", Formula["node@24"].opt_bin
    ENV.prepend_path "PATH", Formula["node@24"].opt_libexec/"bin"

    system "npx", "-y", "pnpm@9.15.0", "install", "--frozen-lockfile"
    system "npx", "-y", "pnpm@9.15.0", "--filter", "@ash-ai/shared", "build"
    system "npx", "-y", "pnpm@9.15.0", "--filter", "@ash-ai/cli", "build"
    system "npx", "-y", "pnpm@9.15.0", "--filter", "@ash-ai/cli", "deploy", "--prod", libexec

    ripgrep_vendor = libexec/"node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    if ripgrep_vendor.directory?
      ripgrep_platform = "#{platform_arch}-#{platform_os}"
      ripgrep_vendor.children.each do |path|
        next if [ripgrep_platform, "COPYING"].include?(path.basename.to_s)

        rm_r path
      end
    end

    sharp_platform = "#{platform_os}-#{platform_arch}"
    sharp_vendor = libexec/"node_modules/.pnpm"
    if sharp_vendor.directory?
      sharp_vendor.children.each do |path|
        basename = path.basename.to_s
        next unless basename.start_with?("@img+sharp-")
        next if basename.include?(sharp_platform)

        rm_r path
      end
    end

    chmod 0755, libexec/"dist/index.js"
    (bin/"ash").write_env_script libexec/"dist/index.js", PATH: node_path
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ash --version")
    assert_match "Container:", shell_output("#{bin}/ash status")
  end
end
