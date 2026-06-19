class Mimirs < Formula
  desc "Local MCP server giving AI coding agents persistent, searchable codebase memory"
  homepage "https://github.com/TheWinci/mimirs"
  url "https://github.com/TheWinci/mimirs/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a443929aed623ff7e90ae3a004a72c3b98ab0d1f9bc84ce7a0ce9362bc42481a"
  license "Apache-2.0"
  head "https://github.com/TheWinci/mimirs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "41b826b2b6d5b51cdb2d0b9f3f5224bad966fcf6506b27bf3a8dbf83baf383d5"
    sha256 cellar: :any, arm64_sequoia: "f864637dc7178e8cb1689d83f96109e44ea4ab37641f7d8318eb508515a0a0a5"
    sha256 cellar: :any, arm64_sonoma:  "f864637dc7178e8cb1689d83f96109e44ea4ab37641f7d8318eb508515a0a0a5"
    sha256 cellar: :any, arm64_linux:   "feb0e079e24724ed0064dc589e2a535e0a7834953dc4b05f3864f3d23ec7199d"
    sha256 cellar: :any, x86_64_linux:  "55522202145f73574a684278e476f9aaece0a3d21f462fe981aa43a6cd93c4a3"
  end

  depends_on "python@3.14" => :build
  depends_on "bun"

  on_macos do
    depends_on "sqlite"
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--production"
    libexec.install Dir["*"]
    (bin/"mimirs").write <<~SH
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" "#{libexec}/src/main.ts" "$@"
    SH
    chmod 0755, bin/"mimirs"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"

    # tree-sitter prebuilds: prebuilds/<os>-<arch>/
    libexec.glob("node_modules/**/prebuilds/*").each do |dir|
      rm_r(dir) if dir.directory? && dir.basename.to_s != native
    end
    expected_arch = if OS.mac?
      Hardware::CPU.arm? ? "arm64" : "x86_64"
    elsif OS.linux?
      Hardware::CPU.arm? ? "aarch64" : "x86-64"
    end
    libexec.glob("node_modules/**/prebuilds/**/*.node").each do |native_file|
      rm native_file unless Utils.safe_popen_read("file", native_file).include?(expected_arch)
    end

    # onnxruntime-node: bin/napi-v*/os/arch/
    libexec.glob("node_modules/onnxruntime-node/bin/napi-v*").each do |napi_dir|
      napi_dir.each_child { |os_dir| rm_r(os_dir) if os_dir.basename.to_s != os }
      native_os = napi_dir/os
      native_os.each_child { |arch_dir| rm_r(arch_dir) if arch_dir.basename.to_s != arch } if native_os.exist?
    end

    if OS.linux?
      libexec.glob("node_modules/@img/sharp-linuxmusl-*").each { |dir| rm_r(dir) if dir.directory? }
      libexec.glob("node_modules/@img/sharp-libvips-linuxmusl-*").each { |dir| rm_r(dir) if dir.directory? }
    end
  end

  test do
    assert_match "\"version\": \"#{version}\"", (libexec/"package.json").read
    require "open3"

    output, status = Open3.capture2e(bin/"mimirs", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output

    (testpath/"test.txt").write "hello world"
    output = shell_output("#{bin}/mimirs init #{testpath} --yes 2>&1", 1)
    assert_match "Created .mimirs/config.json", output
    assert_path_exists testpath/".mimirs/config.json"
  end
end
