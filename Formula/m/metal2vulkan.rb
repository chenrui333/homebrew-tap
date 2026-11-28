class Metal2vulkan < Formula
  desc "Translate Metal AIR shaders to Vulkan SPIR-V"
  homepage "https://github.com/steelbrain/metal2vulkan"
  url "https://github.com/steelbrain/metal2vulkan/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ca3063a7b83e10fabc5a60ccec04f847d0fc7e419121a1336aabb9627fca8341"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/steelbrain/metal2vulkan.git", branch: "master"

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
