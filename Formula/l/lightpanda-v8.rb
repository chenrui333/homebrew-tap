class LightpandaV8 < Formula
  desc "Fork-specific V8 archive and Zig module layout for Lightpanda"
  homepage "https://github.com/lightpanda-io/zig-v8-fork"
  url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ffc009ac48485154b3e622b65fcef3306a1f480992a6ad6ccda7aaff85fcc8c2"
  license "MIT"
  head "https://github.com/lightpanda-io/zig-v8-fork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d12552cce13b1926c72ca8759ccab480d2594e59d14fdc037ef9303cabf69d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e82e5f39f64b5066260a22a4b2bf3fb0155260d6da8fe7ac25d668ecbd90223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29cd38cc634decb60c2f6231a755ba0b8a25f7247fb23f56768fe647377dcae5"
    sha256 cellar: :any_skip_relocation, sequoia:       "5aadf2a22745d036b7f5797c1cb5f27359e006805a9ce75ae66c1b6aebcc7abc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c7b4e98b96ac63fa7546c9fede58c355f5a315e485fb6aafc17436b31b092dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a5f52d1711502ac3af2b4f7f1fdaafa0daa97c0ea8748d1f89710663c01d94"
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
