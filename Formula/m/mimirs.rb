class Mimirs < Formula
  desc "Local MCP server giving AI coding agents persistent, searchable codebase memory"
  homepage "https://github.com/TheWinci/mimirs"
  url "https://github.com/TheWinci/mimirs/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "dfa7fd231223422d6fdd9d22a6f4f44c93fe2e637afa218df1e353f555a74cdd"
  license "Apache-2.0"
  head "https://github.com/TheWinci/mimirs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "73fcddd3e62b73dc55fbe0a21fedd237ddbf4d36d1ac76b128b390c88a1b20f8"
    sha256 cellar: :any, arm64_sequoia: "c5327e870ec4c435df618240efaaa1a0e2e335b1162e6299ffd9a77d05e7833e"
    sha256 cellar: :any, arm64_sonoma:  "c5327e870ec4c435df618240efaaa1a0e2e335b1162e6299ffd9a77d05e7833e"
    sha256 cellar: :any, arm64_linux:   "62bd2ab885826c2c44e70dedb6dafecee3d7d21b1956cf1ae7be64d31928f951"
    sha256 cellar: :any, x86_64_linux:  "dd1304ea5abf4aa2d0c558550e70263ab1a12db7c13d39047ebbc83351be3e03"
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
