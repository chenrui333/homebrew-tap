class LightpandaV8 < Formula
  desc "Fork-specific V8 archive and Zig module layout for Lightpanda"
  homepage "https://github.com/lightpanda-io/zig-v8-fork"
  url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ffc009ac48485154b3e622b65fcef3306a1f480992a6ad6ccda7aaff85fcc8c2"
  license "MIT"
  head "https://github.com/lightpanda-io/zig-v8-fork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74dc08fa847764f7188feb14750483d93d6a7e26e7e7272b47fa3aaddc34acb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d6d297358d0d59e527b10ec23cc3fe3e490ed552e56961a6b51f12bcaa51659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f950c74d74eaed56c67e77d25e56ecac33233362a0d8c63e8fa496a36ba483a"
    sha256 cellar: :any_skip_relocation, sequoia:       "cd7427949158964d3bc91fb2c0f54a0ac288dc8d809fb2d81f499dda9c593786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "510b12ba5a25bb9e33249d40b8529b1597ef0297917d2ebb46c51a4d0491d441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddce3468566593c6cb4ac554e7c00171fdcd3a666950ede0645b922a3609ea84"
  end

  if OS.mac? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_macos_aarch64.a"
      sha256 "c9fb1286e07447d097a704d5ff1b305172f359796e20aaf132deee2d502acca0"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_macos_x86_64.a"
      sha256 "ea2037790c93bb45e8156219fb44638bb9f10ed6cbd988b62d88d39204b40167"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_linux_aarch64.a"
      sha256 "1427c46de6da4918597640a720e2ba725410f41dcac57626291dd025a5968f69"
    end
  else
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_linux_x86_64.a"
      sha256 "b875439b3df025a2da510388559fe66c4454ed660bc38101c54dd55af0b5d0c7"
    end
  end

  def install
    module_root = pkgshare/"zig-v8-fork"
    module_root.mkpath
    cp_r Dir["*"] + Dir[".*"] - %w[. ..], module_root

    build_zon = module_root/"build.zig.zon"
    build_zon_content = build_zon.read
    unless build_zon_content.sub!(
      /    \.dependencies = \.\{\n.*?    \},\n(?=    \.paths = \.\{)/m,
      "    .dependencies = .{},\n",
    )
      odie "Failed to rewrite zig-v8-fork dependency stanza"
    end
    build_zon_content.gsub!("\"README\",", "\"README.md\",")
    build_zon.atomic_write build_zon_content

    lib.install resource("libc_v8").cached_download => "libc_v8.a"
  end

  test do
    module_root = pkgshare/"zig-v8-fork"
    assert_path_exists module_root/"build.zig"
    assert_path_exists module_root/"build.zig.zon"
    assert_path_exists module_root/"src/v8.zig"
    assert_path_exists lib/"libc_v8.a"

    build_zon = (module_root/"build.zig.zon").read
    assert_match ".dependencies = .{},", build_zon
    assert_match "\"README.md\",", build_zon
    assert_match "current ar archive", shell_output("file #{lib}/libc_v8.a")
  end
end
