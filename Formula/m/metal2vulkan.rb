class Metal2vulkan < Formula
  desc "Translate Metal AIR shaders to Vulkan SPIR-V"
  homepage "https://github.com/steelbrain/metal2vulkan"
  url "https://github.com/steelbrain/metal2vulkan/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ca3063a7b83e10fabc5a60ccec04f847d0fc7e419121a1336aabb9627fca8341"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/steelbrain/metal2vulkan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7c4011e28a4b79e8fc788d625548f3d91816b2fb6c6fdea6742061aa9d5873b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2f7caec34f1aa9002e03c45a9a0994a114b27ea76bab6012fefe2bd262c7fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48222bfed76f3c744a8c3b9bb59b904cfdaaa69a9f1752906e187d51ddfdad26"
    sha256 cellar: :any,                 arm64_linux:   "8c3e0935d71a158db81dbda141f1ec14f1e4ea54cd704ce6bfc969f5a9d9899f"
    sha256 cellar: :any,                 x86_64_linux:  "fc6f100b1ff6b3d8f9d7e79ebc1a0dd400dd15d89061b87c70651051e6c596f3"
  end

  depends_on "rust" => :build
  depends_on "spirv-tools" => :test

  deny_network_access!

  def fetch
    # Upstream's workspace config enables nightly flags for development builds.
    rm ".cargo/config.toml"
    system "cargo", "generate-lockfile" unless Pathname("Cargo.lock").exist?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/metal2vulkan"), "--features", "cli"

    validation = buildpath/"crates/metal2vulkan-validation"
    pkgshare.install validation/"fixtures/public/engine/ob3_texture_array.air", validation/"profiles/moltenvk-m3.json"
  end

  def caveats
    <<~EOS
      LLVM text (.ll) input requires llvm-as 21 or newer. If it is not on PATH,
      set METAL2VULKAN_LLVM_AS to the path of llvm-as.
    EOS
  end

  test do
    system bin/"metal2vulkan", pkgshare/"ob3_texture_array.air", "kernel.spv",
                               "--profile", pkgshare/"moltenvk-m3.json", "--emit-meta", "kernel.json",
                               "--no-spirv-val"
    assert_equal "compute", JSON.parse((testpath/"kernel.json").read).fetch("kind")
    system "spirv-val", "--target-env", "vulkan1.2", "kernel.spv"
  end
end
