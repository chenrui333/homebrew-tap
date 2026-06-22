class Mimirs < Formula
  desc "Local MCP server giving AI coding agents persistent, searchable codebase memory"
  homepage "https://github.com/TheWinci/mimirs"
  url "https://github.com/TheWinci/mimirs/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "613ffbdf52d3440ebeaad37804476e58e463cae399b10c8410c437c843322b00"
  license "Apache-2.0"
  head "https://github.com/TheWinci/mimirs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "2da23376506aef4d455a1962dfdf23946665636f60163eebdf71c3ece2eb05e7"
    sha256 cellar: :any, arm64_sequoia: "e2486273d85089a19464bc0eff521f255f8a9cb1840a5ccc5e23f2ac104cfc07"
    sha256 cellar: :any, arm64_sonoma:  "e2486273d85089a19464bc0eff521f255f8a9cb1840a5ccc5e23f2ac104cfc07"
    sha256 cellar: :any, arm64_linux:   "db4ceb19c13d598ac684dabbe5d6221bb3e2b18801c05c8befb703d1aaeeefe7"
    sha256 cellar: :any, x86_64_linux:  "b9e788b4fc4ffdf1e512109f96dfa6841bc23cf71776f7720ff8d383286c9f35"
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
