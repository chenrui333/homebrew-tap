class CavemanCode < Formula
  desc "Minimal terminal coding agent and multi-provider LLM toolkit"
  homepage "https://github.com/JuliusBrussee/caveman-code"
  url "https://registry.npmjs.org/@juliusbrussee/caveman-code/-/caveman-code-0.65.2.tgz"
  sha256 "a755378b0e39c692285ced5201eab47c28149e8b84ce8bda4b5da058ef578baa"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_mods = libexec/"lib/node_modules/@juliusbrussee/caveman-code/node_modules"

    # koffi: build/koffi/<os_arch>/
    (node_mods/"koffi/build/koffi").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }

    # onnxruntime-node: bin/napi-v6/<os>/<arch>/
    onnx_bin = node_mods/"onnxruntime-node/bin/napi-v6"
    onnx_bin.each_child { |os_dir| rm_r(os_dir) if os_dir.basename.to_s != os }
    (onnx_bin/os).each_child { |arch_dir| rm_r(arch_dir) if arch_dir.basename.to_s != arch }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/caveman-code --version 2>&1")

    output = shell_output("#{bin}/caveman-code -p 'hello' < /dev/null 2>&1", 1)
    assert_match "No API key found", output
  end
end
